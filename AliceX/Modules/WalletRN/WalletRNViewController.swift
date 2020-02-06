//
//  WalletRNViewController.swift
//  DAOstack
//
//  Created by lmcmz on 7/2/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import UIKit
import JXSegmentedView

class WalletRNViewController: BaseViewController {

    @IBOutlet var container: UIView!
    @IBOutlet var segmentedContainer: UIView!
    
    var dataSource: JXSegmentedTitleImageDataSource!
    var segmentedView = JXSegmentedView()
    var listContainerView: JXSegmentedListContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        segmentedView.delegate = self
        segmentedContainer.addSubview(segmentedView)
        segmentedView.fillSuperview()

        dataSource = JXSegmentedTitleImageDataSource()
        dataSource.titleNormalColor = AliceColor.greyNew()
        dataSource.titleSelectedColor = AliceColor.darkGrey()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titles = ["Asset", "Setting"]
        dataSource.imageSize = CGSize(width: 20, height: 20)
        dataSource.titleImageType = .leftImage
        dataSource.titleNormalFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        dataSource.normalImageInfos = ["asset-tab", "setting-tab"]
        dataSource.loadImageClosure = { imageView, normalImageInfo in
            imageView.image = UIImage(named: normalImageInfo)
        }
        dataSource.reloadData(selectedIndex: 0)
        
        segmentedView.dataSource = dataSource
        
        let indicator = JXSegmentedIndicatorLineView()
       indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthenOffset
       indicator.indicatorColor = AliceColor.darkGrey()
       segmentedView.indicators = [indicator]

       listContainerView = JXSegmentedListContainerView(dataSource: self, type: .collectionView)
       segmentedView.listContainer = listContainerView

       container.addSubview(listContainerView)
       listContainerView.fillSuperview()
    }
    
    @IBAction func closeButtonClicked() {
        guard let navi = self.navigationController else {
            dismiss(animated: true, completion: nil)
            return
        }
        navi.dismiss(animated: true, completion: nil)
    }
    
}

extension WalletRNViewController: JXSegmentedListContainerViewDataSource {
    
    func listContainerView(_: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        if index == 0 {
            let vc = AssetViewController()
            
            return vc
        }
        
        let vc = SettingViewController()
        vc.hideNavBar = true
        return vc
    }
}

extension WalletRNViewController: JXSegmentedViewDelegate {

    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        return 2
    }
}
