//
//  View.swift
//  Read Us
//
//  Created by Kuba Milcarz on 12/23/22.
//

import SwiftUI

extension View {
    func hideKeyboard() -> Void {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
