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
    
    @Published private(set) var state = State.start
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
    
    func searchStatusChanged(_ value: SearchBar.Status) {
        let event: Event = {
            switch value {
            case .searching:
                isSearching = true
                return .startSearch
            case .searched:
                searchRecipe()
                return .search
            case .notSearching:
                return .cancel
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
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            self.isSearching = false
            
            return self.service.searchRecipe(.search(self.searchText))
                .tryMap({ list in
                    guard let drinks = list.drinks else {
                        throw APIError.invalidData
                    }
                    self.state = .start
                    return drinks.map(ListItem.init)
                })
                .map(Event.onSuccess)
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
        case start
        case searching
        case loading
        case searchResults([ListItem])
        case error(Error)
    }
    
    enum Event {
        case startSearch
        case cancel
        case search
        case onSuccess([ListItem])
        case onFailure(Error)
    }
    
    struct ListItem: Identifiable, Hashable {
        let id: String
        let title: String
        let thumb: String
        let category: String
        var tags: [String]?
        
        init(drink: Drink) {
            id = drink.id
            title = drink.name
            thumb = drink.thumb
            category = drink.category ?? "N/A"
            tags = getTags(drink: drink)
        }
        
        private func getTags(drink: Drink) -> [String]? {
            if let string = drink.tags {
                let tags = string.split(separator: ",").map({String($0)})
                return tags
            }
            return nil
        }
    }
}

extension SearchListViewModel {
    
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .start:
            switch event {
            case .startSearch:
                return .searching
            default:
                return state
            }
        case .searching:
            switch event {
            case .search:
                return .loading
            case .cancel:
                return .start
            default:
                return state
            }
        case .loading:
            switch event {
            case .onSuccess(let items):
                return .searchResults(items)
            default:
                return state
            }
        case .searchResults(_):
            switch event {
            case .startSearch:
                return .searching
            default:
                return state
            }
        case .error(_):
            return state
        }
    }
}
