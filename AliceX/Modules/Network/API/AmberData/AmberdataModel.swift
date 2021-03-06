//
//  AmberdataModel.swift
//  AliceX
//
//  Created by lmcmz on 5/11/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation
import HandyJSON

struct AmberdataTokenPrice: HandyJSON {
    var address: String!
    var symbol: String!
    var name: String!
}

struct AmberdataBalance: HandyJSON {
    var value: String!
}

struct AmberdataTokenList: HandyJSON {
    var records: [AmberdataToken]!
    var totalRecords: Int!
}

struct AmberdataToken: HandyJSON {
    var address: String!
    var holder: String!
    var amount: String!
    var decimals: Int!
    var name: String!
    var symbol: String!
    var isERC20: Bool!
    var isERC777: Bool!
    var isERC721: Bool!
    var isERC884: Bool!
    var isERC998: Bool!
}

struct AmberdataAddress: HandyJSON {
    var address: String!
}

struct AmberdataTXRecord: HandyJSON {
    var transactionHash: String!
    var blockHash: String!
    var blockNumber: String!
    var tokenAddress: String!
    var amount: String!
    var timestamp: Int64!
    var timestampNanoseconds: Int!
    var logIndex: Int!
    var blockchainId: String!
    var to: AmberdataAddress!
    var from: AmberdataAddress!
    var decimals: Int!
    var name: String!
    var symbol: String!
    var isERC20: Bool!
    var isERC777: Bool!
    var isERC721: Bool!
    var isERC884: Bool!
    var isERC998: Bool!
}
