//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import Foundation
import UIKit
fileprivate var tempView: UIView?

extension UIViewController {
    func showActivityIndicator() {
        guard tempView == nil else { return }
        tempView = UIView(frame: self.view.bounds)
        tempView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = tempView!.center
        ai.startAnimating()
        ai.color = .red
        tempView?.addSubview(ai)
        self.view.addSubview(tempView!)
    }
    
    func dismissActivityIndicator() {
        tempView?.removeFromSuperview()
        tempView = nil
    }
}
