//
//  UIDevice.swift
//  Read Us
//
//  Created by Kuba Milcarz on 11/30/22.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
