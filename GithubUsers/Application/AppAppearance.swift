//
//  AppAppearance.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/3/21.
//

import Foundation
import UIKit

class AppAppearance {
    static func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
