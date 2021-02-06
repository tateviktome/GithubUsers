//
//  UIViewController+Alert.swift
//  GithubUsers
//
//  Created by Tatevik Tovmasyan on 2/6/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}
