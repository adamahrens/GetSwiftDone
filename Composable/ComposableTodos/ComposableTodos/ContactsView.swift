//
//  ContactsView.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 2/29/24.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
  @Bindable var store: StoreOf<ContactsFeature>
  
  var body: some View {
    NavigationStack {
      List(store.contacts) { contact in
        Text(contact.name)
      }
      .navigationTitle("Contacts")
      .toolbar {
        ToolbarItem {
          Button {
            store.send(.addButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
        }
      }
    }
    .sheet(item: $store.scope(state: \.addContact, action: \.addContact)) { contactStore in
      NavigationStack {
        AddContactView(store: contactStore)
      }
    }
  }
}

#Preview {
  ContactsView(store: Store(initialState: ContactsFeature.State(contacts: [
    Contact(id: UUID(), name: "Adam"),
    Contact(id: UUID(), name: "Claudia"),
    Contact(id: UUID(), name: "Francis")
  ])) {
    ContactsFeature()
  })
}
