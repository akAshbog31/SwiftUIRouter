//
//  SwiftUI_RouterApp.swift
//  SwiftUI Router
//
//  Created by iOS Developer on 26/12/23.
//

import SwiftUI

public typealias Router = AppRouter<Route>

@main
struct SwiftUI_RouterApp: App {
    var body: some Scene {
        WindowGroup {
            Router.Stack {
                ContentView()
            }
        }
    }
}

public enum Route: AppRoute {
    case contentView
    case view1
    case view2
    case view3
    
    public var id: String {
        return UUID().uuidString
    }

    @ViewBuilder
    public var content: some View {
        switch self {
        case .contentView: ContentView()
        case .view1: View1()
        case .view2: View2()
        case .view3: View3()
        }
    }
}
