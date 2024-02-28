//
//  ContentView.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 2/28/24.
//

import SwiftUI
import ComposableArchitecture

struct CreateTodo: View {
  let store: StoreOf<CreateTodoFeature>

  @State private var todo = ""
  
  var body: some View {
    VStack {
      Text("Number of todos: \(store.todos.count)")
      
      TextField("Title", text: $todo, prompt: Text("Add a Todo"))
        .padding()
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
      
      Button(role: .cancel) {
        guard !todo.isEmpty else { return }
        store.send(.addTodo(Todo(title: todo, complete: false)))
        todo = ""
      } label: {
        Text("Save")
          .padding(.vertical)
          .stretch(.horizontal)
          .blackWhite()
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      
      Button(role: .cancel) {
        store.send(.findFact)
      } label: {
        Text("Network Request")
          .padding(.vertical)
          .stretch(.horizontal)
          .blackWhite()
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      
      if store.isLoading {
        ProgressView()
      } else if let fact = store.fact {
        Text(fact)
          .font(.largeTitle)
          .multilineTextAlignment(.center)
          .padding()
      }
      
      Button(role: .cancel) {
        store.send(.toggleTimer)
      } label: {
        Text(store.timerLabel)
          .padding(.vertical)
          .stretch(.horizontal)
          .blackWhite()
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      
      if store.timeAgo > 0 {
        Text("\(store.timeAgo) seconds ago")
      }

      Spacer()
    }
    .padding()
  }
}

#Preview {
  CreateTodo(store: Store(initialState: CreateTodoFeature.State()) {
    CreateTodoFeature()
  })
}

struct ButtonColorScheme: ViewModifier {
  
  @Environment(\.colorScheme) var colorScheme
  var bordered: Bool = false
  var cornerRadius: CGFloat
  
  func body(content: Content) -> some View {
    if bordered {
      content
        .foregroundStyle(colorScheme == .dark ? .white : .black)
        .background(colorScheme == .dark ? .black : .white)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
      
    } else {
      content
        .foregroundStyle(colorScheme == .dark ? .black : .white)
        .background(colorScheme == .dark ? .white : .black)
    }
  }
}

enum StretchDirection: String, CaseIterable, Identifiable {
  case horizontal
  case vertical
  case leading
  case trailing
  case top
  case bottom
  
  var id: String { rawValue }
}

struct StretchModifier: ViewModifier {
  let stretch: StretchDirection
  
  func body(content: Content) -> some View {
    switch stretch {
    case .horizontal:
      HStack {
        Spacer()
        content
        Spacer()
      }
    case .leading:
      HStack {
        Spacer()
        content
      }
    case .trailing:
      HStack {
        content
        Spacer()
      }
    case .vertical:
      VStack {
        Spacer()
        content
        Spacer()
      }
    case .top:
      VStack {
        Spacer()
        content
      }
    case .bottom:
      VStack {
        content
        Spacer()
      }
    }
  }
}

extension View {
  func blackWhite(bordered: Bool = false, cornerRadius: CGFloat = 8) -> some View {
    modifier(ButtonColorScheme(bordered: bordered, cornerRadius: cornerRadius))
  }
  
  func blackWhiteBordered(cornerRadius: CGFloat = 8) -> some View {
    modifier(ButtonColorScheme(bordered: true, cornerRadius: cornerRadius))
  }
  
  /// Puts a View in an HStack or VStack based on the stretch direction with Spacer()
  /// on each side to help center
  func stretch(_ stretch: StretchDirection) -> some View {
    modifier(StretchModifier(stretch: stretch))
  }
}
