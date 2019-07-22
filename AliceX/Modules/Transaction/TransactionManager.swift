//
//  TransactionManager.swift
//  AliceX
//
//  Created by lmcmz on 10/6/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import UIKit
import SPStorkController
import web3swift
import BigInt

// TODO: Change all function to Promise
class TransactionManager {
    static let shared = TransactionManager()
    
    // MARK: - Smart Contract Popup
    
    class func showContractWriteView(contractAddress: String,
                                     functionName: String,
                                     abi: String,
                                     parameters: [Any],
                                     value: BigUInt,
                                     extraData: Data,
                                     success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = ContractPopUp.make(contractAddress: contractAddress,
                                       functionName: functionName, parameters: parameters,
                                       extraData: extraData, value: value, abi: abi, success: success)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 525 - 34 + Constant.SAFE_BTTOM
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        topVC?.present(modal, animated: true, completion: nil)
    }
    
    class func getAddress() throws -> String {
        guard let address = WalletManager.wallet?.address else { throw WalletError.accountDoesNotExist }
        return address
    }

    // MARK: - Balance
    
    public func etherBalanceSync() throws -> String {
        guard let address = WalletManager.wallet?.address else { throw WalletError.accountDoesNotExist }
        guard let ethereumAddress = EthereumAddress(address) else { throw WalletError.invalidAddress }
        
        guard let balanceInWeiUnitResult = try? WalletManager.web3Net.eth.getBalance(address: ethereumAddress) else {
            throw WalletError.insufficientBalance
        }

        guard let balanceInEtherUnitStr = Web3.Utils.formatToEthereumUnits(balanceInWeiUnitResult,
                                                                           toUnits: .eth,
                                                                           decimals: 6, decimalSeparator: ".")
            else { throw WalletError.conversionFailure }
        
        return balanceInEtherUnitStr
    }

    public func etherBalance(completion: @escaping (String?) -> Void) {
        DispatchQueue.global().async {
            let balance = try? self.etherBalanceSync()
            DispatchQueue.main.async {
                completion(balance)
            }
        }
    }

    // MARK: - Send Transaction
    
    class func showPaymentView(toAddress: String,
                               amount: BigUInt,
                               data: Data,
                               symbol: String, success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = PaymentPopUp.make(toAddress: toAddress, amount: amount, data: data, symbol: symbol, success: success)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 430 - 34 + Constant.SAFE_BTTOM
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        topVC?.present(modal, animated: true, completion: nil)
    }

    public func sendEtherSync(to address: String,
                              amount: BigUInt,
                              data: Data,
                              password: String,
                              gasPrice: GasPrice = GasPrice.average) throws -> String {
        
        do {
            let result = try TransactionManager.writeSmartContract(contractAddress: address,
                                                                   functionName: "transfer",
                                                                   abi: Web3.Utils.coldWalletABI,
                                                                   parameters: [AnyObject](),
                                                                   extraData: data,
                                                                   value: amount)
            return result
        } catch let error as WalletError {
            HUDManager.shared.showError(text: error.errorDescription)
        } catch let error as Web3Error {
            HUDManager.shared.showError(text: error.errorDescription)
        } catch {
            HUDManager.shared.showError(text: "Send ERC20 Failed")
        }
        return "Send ETH Failed"
    }
    
    // MARK: - Payment Popup
    
    class func showRNCustomPaymentView(toAddress: String,
                                       amount: BigUInt,
                                       height: CGFloat = 500,
                                       data: Data,
                                       success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = RNCustomPopUp.make(toAddress: toAddress, amount: amount,
                                       height: height, data: data, successBlock: success)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = height
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        topVC?.present(modal, animated: true, completion: nil)
    }
    
    // MARK: - Send ERC20
    
    public func sendERC20Token(to address: String,
                               amount: BigUInt,
                               data: Data,
                               password: String,
                               gasPrice: GasPrice = GasPrice.average) throws -> String {
        
        guard let toAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        let parameters = [toAddress, amount] as [AnyObject]
        
        do {
            let result = try TransactionManager.writeSmartContract(contractAddress: address,
                                                               functionName: "transfer",
                                                               abi: Web3.Utils.erc20ABI,
                                                               parameters: parameters,
                                                               extraData: data,
                                                               value: amount)
            return result
        } catch let error as WalletError {
            HUDManager.shared.showError(text: error.errorDescription)
        } catch let error as Web3Error {
            HUDManager.shared.showError(text: error.errorDescription)
        } catch {
            HUDManager.shared.showError(text: "Send ERC20 Failed")
        }
        return "Send ERC20 Failed"
    }
    
    // MARK: - Call Smart Contract

    public class func writeSmartContract(contractAddress: String,
                                         functionName: String,
                                         abi: String,
                                         parameters: [Any],
                                         extraData: Data,
                                         value: BigUInt,
                                         gasPrice: GasPrice = GasPrice.average) throws -> String {
        
        guard let address = WalletManager.wallet?.address else {
            throw WalletError.invalidAddress
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let contractAddress = EthereumAddress(contractAddress) else {
            throw WalletError.invalidAddress
        }
        
        let etherBalance = try TransactionManager.shared.etherBalanceSync()
        guard let etherBalanceInDouble = Double(etherBalance) else {
            throw WalletError.conversionFailure
        }
        
        guard let amountInDouble = Double(value.readableValue) else {
            throw WalletError.conversionFailure
        }
        
        guard etherBalanceInDouble >= amountInDouble else {
            throw WalletError.insufficientBalance
        }
        
        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }
        
        let gasPrice = GasPrice.average.wei
        let contract = WalletManager.web3Net.contract(abi, at: contractAddress, abiVersion: 2)
        
        var options = TransactionOptions.defaultOptions
        options.value = value
        options.from = walletAddress
        options.gasPrice = .manual(gasPrice)
        options.gasLimit = .automatic
        let tx = contract!.write(
            functionName,
            parameters: parameters as [AnyObject],
            extraData: extraData,
            transactionOptions: options)!
        
        do {
            let sendResult = try tx.send()
            return sendResult.hash
        } catch let error as Web3Error {
            HUDManager.shared.showError(text: error.errorDescription)
        }
        
        return "Error"
    }
    
    public class func readSmartContract(contractAddress: String, functionName: String,
                                        abi: String, parameters: [Any], value: String = "0.0") throws -> String {
        
        guard let address = WalletManager.wallet?.address else {
            throw WalletError.invalidAddress
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let contractAddress = EthereumAddress(contractAddress) else {
            throw WalletError.invalidAddress
        }
        
        let abiVersion = 2
        let extraData: Data = Data()
        let contract = WalletManager.web3Net.contract(abi, at: contractAddress, abiVersion: abiVersion)
        let amount = Web3.Utils.parseToBigUInt(value, units: .eth)
        
        var options = TransactionOptions.defaultOptions
        options.value = amount
        options.from = walletAddress
        options.gasPrice = .automatic
        options.gasLimit = .automatic
        let tx = contract!.read(
            functionName,
            parameters: parameters as [AnyObject],
            extraData: extraData,
            transactionOptions: options)
        
        guard let sendResult = try? tx?.call() else {
            throw WalletError.networkFailure
        }
        print(sendResult.keys)
        
        return ""
    }
    
    // MARK: - Sign Message
    
    class func showSignMessageView(message: String, success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = SignMessagePopUp.make(message: message, success: success)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 420 - 34 + Constant.SAFE_BTTOM
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        topVC?.present(modal, animated: true, completion: nil)
    }
    
    class func signMessage(message: Data) throws -> String? {
        
        guard let address = WalletManager.wallet?.address else {
            throw WalletError.invalidAddress
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }
        
        do {
            let signedData = try Web3Signer.signPersonalMessage(message,
                                                                 keystore: keystore,
                                                                 account: walletAddress,
                                                                 password: Setting.password)
            return (signedData?.toHexString().addHexPrefix())!
        } catch {
            throw WalletError.messageFailedToData
        }
    }
    
    // MARK: - Sign Transaction
    
    class func showSignTransactionView(to:String, value: BigUInt, data: Data, success: @escaping StringBlock) {
        let topVC = UIApplication.topViewController()
        let modal = SignTransactionPopUp.make(toAddress: to, amount: value, data: data, success: success)
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.customHeight = 430 - 34 + Constant.SAFE_BTTOM
        modal.transitioningDelegate = transitionDelegate
        modal.modalPresentationStyle = .custom
        topVC?.present(modal, animated: true, completion: nil)
    }
    
    class func signTransaction(to address: String,
                               amount: BigUInt,
                               data: Data,
                               gasPrice: GasPrice = GasPrice.average) throws -> String {
        
        guard let toAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let address = WalletManager.wallet?.address else {
            throw WalletError.invalidAddress
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        let etherBalance = try TransactionManager.shared.etherBalanceSync()
        guard let etherBalanceInDouble = Double(etherBalance) else {
            throw WalletError.conversionFailure
        }
        
        guard let amountInDouble = Double(amount.readableValue) else {
            throw WalletError.conversionFailure
        }
        
        guard etherBalanceInDouble >= amountInDouble else {
            throw WalletError.insufficientBalance
        }
        
        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }
        
        let gasPrice = GasPrice.average.wei
        let value = amount
        var options = TransactionOptions.defaultOptions
        options.value = value
        options.from = walletAddress
        options.gasPrice = .manual(gasPrice)
        options.gasLimit = .automatic
        
        var tx = EthereumTransaction(to: toAddress, data: data, options: options)
        do {
            try Web3Signer.signTX(transaction: &tx,
                                  keystore: keystore,
                                  account: walletAddress,
                                  password: Setting.password)
            
            print(tx.description)
            return (tx.encode(forSignature: false, chainID: nil)?.toHexString().addHexPrefix())!
            // return tx.toJsonString()
        } catch {
            HUDManager.shared.showError()
        }
        
        return "Sign Transaction Failed"
    }
    
    // MARK: - Validator
    
    
    func validator(address: String, data: Data, value: BigUInt) throws -> Bool {
        
        guard let toAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        guard let address = WalletManager.wallet?.address else {
            throw WalletError.invalidAddress
        }
        
        guard let walletAddress = EthereumAddress(address) else {
            throw WalletError.invalidAddress
        }
        
        let etherBalance = try TransactionManager.shared.etherBalanceSync()
        guard let etherBalanceInDouble = Double(etherBalance) else {
            throw WalletError.conversionFailure
        }
        
        guard let amountInDouble = Double(value.readableValue) else {
            throw WalletError.conversionFailure
        }
        
        guard etherBalanceInDouble >= amountInDouble else {
            throw WalletError.insufficientBalance
        }
        
        guard let keystore = WalletManager.web3Net.provider.attachedKeystoreManager else {
            throw WalletError.malformedKeystore
        }
        
        return true
    }
}
