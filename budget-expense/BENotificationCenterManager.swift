//
//  BENotificationCenterManager.swift
//  budget-expense
//
//  Created by Matteo Comisso on 15/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation

final class BENotificationCenterManager {

    private var observerTokens: [AnyObject] = []

    deinit {
        deregisterAll()
    }

    func deregisterAll() {
        for token in observerTokens {
            NotificationCenter.default.removeObserver(token)
        }

        observerTokens = []
    }

    func registerObserver(name: Notification.Name, block: @escaping ((Notification) -> Void)) {
        let newToken = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: block)

        observerTokens.append(newToken)
    }

    func registerObserver(name: Notification.Name, forObject object: AnyObject, block: @escaping ((Notification) -> Void)) {
        let newToken = NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: block)
        
        observerTokens.append(newToken)
    }
}
