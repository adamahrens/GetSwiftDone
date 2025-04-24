//
//  ContactsFeature.swift
//  ComposableTodos
//
//  Created by Adam Ahrens on 2/29/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ContactsFeature {
  @ObservableState
  struct State: Equatable {
    
    // Will represent nil ( feature not presented), or presented
    @Presents var addContact: AddContactFeature.State?
    
    var contacts = IdentifiedArrayOf<Contact>(uniqueElements: [])
  }
  
  enum Action {
    case addButtonTapped
    case addContact(PresentationAction<AddContactFeature.Action>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.addContact = AddContactFeature.State(contact: Contact(id: UUID(), name: ""))
        return .none
      case let .addContact(.presented(.delegate(.saveContact(contact)))):
        state.contacts.append(contact)
        return .none
      case .addContact:
        return .none
      }
    }
    .ifLet(\.$addContact, action: \.addContact) {
      AddContactFeature()
    }
  }
}
