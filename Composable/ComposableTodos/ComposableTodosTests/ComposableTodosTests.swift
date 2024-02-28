//
//  ComposableTodosTests.swift
//  ComposableTodosTests
//
//  Created by Adam Ahrens on 2/28/24.
//

import ComposableArchitecture
import XCTest
@testable import ComposableTodos

@MainActor
final class ComposableTodosTests: XCTestCase {
  func testAddTodos() async {
    let store = TestStore(initialState: CreateTodoFeature.State()) {
      CreateTodoFeature()
    }
    
    XCTAssertTrue(store.state.todos.count == 0)
    await store.send(.addTodo(Todo(title: "hello", complete: false))) {
      // Have to describe how the state changes after a send
      $0.todos = [Todo(title: "hello", complete: false)]
    }
    await store.send(.addTodo(Todo(title: "world", complete: false))) {
      // What the state should look like again
      $0.todos = [Todo(title: "hello", complete: false), Todo(title: "world", complete: false)]
    }
    
    XCTAssertTrue(store.state.todos.count == 2)
  }
}
