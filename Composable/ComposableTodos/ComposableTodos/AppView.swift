//
//  AppView.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 2/28/24.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
  let store: StoreOf<AppFeature>
  
  var body: some View {
    TabView {
      CreateTodo(store: store.scope(state: \.tab1, action: \.tab1))
        .tabItem { Text("Create1") }
      CreateTodo(store: store.scope(state: \.tab2, action: \.tab2))
        .tabItem { Text("Create2") }
    }
  }
}

#Preview {
  AppView(store: Store(initialState: AppFeature.State(), reducer: {
    AppFeature()
  }))
}
