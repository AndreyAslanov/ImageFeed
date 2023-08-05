//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Андрей Асланов on 12.07.23.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {

    static var isShowing: Bool = false

    private static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return nil
        }
        return window
    }

    static func show() {
        isShowing = true
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    static func dismiss() {
        isShowing = false
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }

    static func showWA() {
        window?.isUserInteractionEnabled = false
    }
    static func dismissWA() {
        window?.isUserInteractionEnabled = true
    }
}

