//
//  ComposableTodosApp.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 2/28/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct ComposableTodosApp: App {
  static let store = Store(initialState: AppFeature.State()) {
    AppFeature()
      ._printChanges()
  }
  
  var body: some Scene {
    WindowGroup {
      // The goal is to have a single store
      // That manages multiple features and allows them to communicate
      // For example one feature might affect how another feature works
      // But we don't want distinct stores
      
      AppView(store: ComposableTodosApp.store)
      
//      TabView {
//        CreateTodo(store: ComposableTodosApp.store)
//          .tabItem { Text("Create1") }
//        CreateTodo(store: ComposableTodosApp.store)
//          .tabItem { Text("Create2") }
//      }
    }
  }
}
