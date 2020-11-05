//
//  MainTab.swift
//  AliceX
//
//  Created by lmcmz on 26/10/19.
//  Copyright © 2019 lmcmz. All rights reserved.
//

import Foundation

enum MainTab: Int, CaseIterable {
    case chat
    case mini
    case asset
    case setting

    var vc: UIViewController {
        switch self {
        case .chat:
            return ChatRoomViewController()
        case .mini:
            return MiniAppViewController()
        case .asset:
            return AssetViewController()
        case .setting:
            let vc = SettingViewController.make(hideBackButton: true)
            return vc
        }
    }

    var icon: UIImage {
        switch self {
        case .chat:
            return UIImage(named: "back")!
        case .mini:
            return UIImage(named: "back")!
        case .asset:
            return UIImage(named: "back")!
        case .setting:
            return UIImage(named: "back")!
//        case .transaction:
//            return UIImage(named: "back")!
//        case .profile:
//            return UIImage(named: "back")!
        }
    }
}
