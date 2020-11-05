//
//  UserManager.swift
//  AliceX
//
//  Created by lmcmz on 18/10/20.
//  Copyright © 2020 lmcmz. All rights reserved.
//

import FirebaseAuth
import Foundation

class UserManager {
    static let shared = UserManager()

    var currentUser: User?

    init() {}

    func signInAnonymously() {
        Auth.auth().signInAnonymously { authResult, _ in
            guard let user = authResult?.user else { return }
            self.currentUser = user
        }
    }
}
