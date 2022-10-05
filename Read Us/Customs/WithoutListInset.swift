//
//  WithoutListInset.swift
//  Read Us
//
//  Created by Kuba Milcarz on 10/5/22.
//

import SwiftUI

struct RemovedListInset: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

extension View {
    func withoutListInset() -> some View {
        modifier(RemovedListInset())
    }
}
