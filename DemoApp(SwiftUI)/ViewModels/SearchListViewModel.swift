//
//  SearchListViewModel.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 03/05/21.
//

import Foundation
import Combine
import SwiftUI

final class SearchListViewModel: ObservableObject {
    
    @Published private(set) var state = State.idle
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    
    private let service = SearchService()
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
    
    var showSearchCancelButton: Bool {
        return isSearching
    }
    
    func searchStatusChanged(_ value: SearchBar.Status) {
        let event: Event = {
            switch value {
            case .searching:
                isSearching = true
                state = .searching
                return .onStart
            case .searched:
                isSearching = false
                state = .searched
                searchRecipe()
                return .onSearch
            case .notSearching:
                state = .idle
                return .onCancel
            }
        }()
        send(event: event)
    }
    
    func searchRecipe() {
        Publishers.system(
            initial: self.state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                whenSearching(),
                userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    func whenSearching() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .searched = state else { return Empty().eraseToAnyPublisher() }
            
            return self.service.searchRecipe(.search(self.searchText))
                .map { $0.drinks!.map(ListItem.init) }
                .map(Event.onDrinksLoaded)
                .catch { Just(Event.onFailure($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

extension SearchListViewModel {
    enum State {
        case idle
        case searching
        case searched
        case loaded([ListItem])
        case error(Error)
    }
    
    enum Event {
        case onStart
        case onCancel
        case onSearch
        case onDrinksLoaded([ListItem])
        case onFailure(Error)
    }
    
    struct ListItem: Identifiable {
        let id: String
        let title: String
        let thumb: String
        
        init(category: Drink) {
            id = category.id
            title = category.name
            thumb = category.thumb
        }
    }
}

extension SearchListViewModel {
    
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            return state
        case .searching:
            return state
        case .searched:
            switch event {
            case .onFailure(let error):
                return .error(error)
            case .onDrinksLoaded(let drinks):
                return .loaded(drinks)
            default:
                return state
            }
        case .loaded(_):
            return state
        case .error(_):
            return state
        }
    }
}
