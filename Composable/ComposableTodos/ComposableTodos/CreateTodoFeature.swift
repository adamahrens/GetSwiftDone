//
//  TodoFeature.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 2/28/24.
//

import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct CreateTodoFeature {
  
  @ObservableState
  struct State: Equatable {
    var todos = [Todo]()
    var fact: String?
    var isLoading = false
    var timerIsFiring = false
    var timeAgo = 0
    
    var timerLabel: String {
      timerIsFiring ? "Stop Timer" : "Start Timer"
    }
  }
  
  enum Action {
    case addTodo(Todo)
    case remove(Todo)
    case findFact
    case newFact(String)
    case toggleTimer
    case timerTick
  }
  
  enum CancelID { case timer }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .timerTick:
        state.timeAgo += 1
        return .none
      case .toggleTimer:
        state.timerIsFiring.toggle()
        if state.timerIsFiring {
          return .run { send in
            while true {
              try await Task.sleep(for: .seconds(1))
              await send(.timerTick)
            }
          }
          .cancellable(id: CancelID.timer)
        } else {
          state.timeAgo = 0
          return .cancel(id: CancelID.timer)
        }
      case .addTodo(let todo):
        state.todos.append(todo)
        state.fact = nil
        return .none
      case .remove(let todo):
        state.todos.removeAll { $0 == todo }
        state.fact = nil
        return .none
      case .newFact(let fact):
        state.fact = fact
        state.isLoading = false
        return .none
      case .findFact:
        state.fact = nil
        state.isLoading = true
        return .run { [count = state.todos.count] send in
          // Ok to do async side effect work here
          let (data, _ ) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(count)")!)
          let fact = String(decoding: data, as: UTF8.self)
          await send(.newFact(fact))
        }
        
        // Cant perform side effects like that
        // Reduce should be pure functional changes/manipulates to state
        
        //        let (data, _ ) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(state.todos.count)"))
        //        state.fact = String(decoding: data, as: .utf8)
        //        state.isLoading = false
        //        return .none
      }
    }
  }
}
