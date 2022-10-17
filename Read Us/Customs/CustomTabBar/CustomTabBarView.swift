//
//  CustomTabBarView.swift
//  Read Us
//
//  Created by Kuba Milcarz on 9/25/22.
//

import SwiftUI

struct CustomTabBarView: View {
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    
    @Namespace private var tabBarNamespace
    @State private var localSelection: TabBarItem
    
    init(tabs: [TabBarItem], selection: Binding<TabBarItem>) {
        self.tabs = tabs
        self._selection = selection
        self._localSelection = State(wrappedValue: selection.wrappedValue)
    }
    
    var body: some View {
        tabBarVersion2
            .onChange(of: selection) { value in
                withAnimation(.easeInOut(duration: 0.2)) {
                    localSelection = value
                }
            }
    }
}

extension CustomTabBarView {
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack(spacing: 3) {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .serif))
        }
        .foregroundColor(localSelection == tab ? tab.color : .gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(tab.color.opacity(localSelection == tab ? 0.2 : 0.001))
        .cornerRadius(12)
    }
    
    private var tabBarVersion1: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
    }
    
    private func switchToTab(tab: TabBarItem) {
        selection = tab
    }
}

extension CustomTabBarView {
    
    private func tabView2(tab: TabBarItem) -> some View {
        VStack(spacing: 5) {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .serif))
        }
        .foregroundColor(localSelection == tab ? tab.color : .gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: tabBarNamespace)
                } else {
                    Color.ruAccentColor.opacity(0.001)
                }
            }
        )
    }
    
    private var tabBarVersion2: some View {
        ZStack {
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    tabView2(tab: tab)
                        .onTapGesture {
                            switchToTab(tab: tab)
                        }
                }
            }
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
//                Color.primary.ignoresSafeArea(edges: .bottom)
            )
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
            .offset(x: 0, y: 5)
        }
    }
    
}
