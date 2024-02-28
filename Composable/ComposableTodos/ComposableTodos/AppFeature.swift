//
//  AppFeature.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 2/28/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
  
  struct State: Equatable {
    var tab1 = CreateTodoFeature.State()
    var tab2 = CreateTodoFeature.State()
  }
  
  enum Action {
    case tab1(CreateTodoFeature.Action)
    case tab2(CreateTodoFeature.Action)
  }
  
  // The basics of composing features together in it's simplest form
  // starts by composing reducers together in the body of a parent
  // reducer and use Scope
  var body: some ReducerOf<Self> {
    // Need to scope foe the child feature to run in the parent feature
    // Add this point AppFeature is composed of 3 independent features, CreateTodoFeature1 for tab 1, CreateTodoFeatures2 for tab2, and the Core AppFeature
    Scope(state: \.tab1, action: \.tab1) {
      CreateTodoFeature()
    }
    
    Scope(state: \.tab2, action: \.tab2) {
      CreateTodoFeature()
    }
    
    Reduce { state, action in
      return .none
    }
  }
}
