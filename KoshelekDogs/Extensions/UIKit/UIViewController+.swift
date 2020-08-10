//
//  UIViewController+.swift
//  KoshelekDogs
//
//  Created by Дмитрий Константинов on 10.08.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

extension UIViewController {

    public class var identifier: String {
        return String.className(self)
    }

    func showAlert(with title: String,
                   and message: String,
                   completion: @escaping () -> Void = { }) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(action)

        alertController
            .setValue(NSAttributedString(
                string: alertController.title!,
                attributes: [NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 15)!,
                             NSAttributedString.Key.foregroundColor: UIColor.black]),
                      forKey: "attributedTitle")

        alertController
            .setValue(NSAttributedString(
                string: alertController.message!,
                attributes: [NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 15)!,
                             NSAttributedString.Key.foregroundColor: UIColor.black]),
                      forKey: "attributedMessage")

        alertController.view.tintColor = .systemBlue
        present(alertController, animated: true, completion: nil)
    }

    func showShareAction(with title: String,
                         and message: String,
                         completion: @escaping () -> Void = { }) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Share", style: .default) { (_) in
            completion()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)

        alertController.addAction(action)
        alertController.addAction(cancel)

        alertController
            .setValue(NSAttributedString(
                string: alertController.title!,
                attributes: [NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 15)!,
                             NSAttributedString.Key.foregroundColor: UIColor.black]),
                      forKey: "attributedTitle")

        alertController
            .setValue(NSAttributedString(
                string: alertController.message!,
                attributes: [NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 15)!,
                             NSAttributedString.Key.foregroundColor: UIColor.black]),
                      forKey: "attributedMessage")

        alertController.view.tintColor = .systemBlue
        present(alertController, animated: true, completion: nil)
    }
}
