//
//  ContentView.swift
//  SwiftUI Router
//
//  Created by iOS Developer on 26/12/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var stackController: Router.StackController
    
    var body: some View {
        VStack {
            Router.Link(to: .view1, presentation: .sheet(detents: [.large])) {
                Text("Go to View1")
            }
        }
        .padding()
    }
}

struct View1: View {
    @EnvironmentObject private var stackController: Router.StackController
    
    var body: some View {
        VStack {
            Button {
                stackController.push(route: .view2)
            } label: {
                Text("Go to View2")
            }
        }
        .padding()
    }
}

struct View2: View {
    @EnvironmentObject private var stackController: Router.StackController
    
    var body: some View {
        VStack {
            Button {
                stackController.push(route: .view3)
            } label: {
                Text("Go to View3")
            }
        }
        .padding()
    }
}

struct View3: View {
    @EnvironmentObject private var stackController: Router.StackController
    
    var body: some View {
        VStack {
            Button {
                stackController.pop(to: .contentView)
            } label: {
                Text("Go to main")
            }
        }
        .padding()
    }
}
