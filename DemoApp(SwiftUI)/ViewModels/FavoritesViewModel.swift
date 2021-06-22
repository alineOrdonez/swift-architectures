//
//  FavoritesViewModel.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Ordoñez Garcia on 21/06/21.
//

import Foundation
import Combine
import SwiftUI

final class FavoritesViewModel: ObservableObject {
    
    @Published private(set) var state: State
    
    private let service = FavoriteService()
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init(_ favorites: [String]) {
        state = .idle(favorites)
        
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                whenLoading(),
                userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
    
    func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading(let ids) = state else { return Empty().eraseToAnyPublisher() }
            
            let arrayOfPublishers = ids.map { id in
                return self.service.getDrinkById(.drink(id))
            }
            
            return Publishers.MergeMany(arrayOfPublishers)
                .compactMap({$0.drinks?.first})
                .collect()
                .map({$0.map(ListItem.init)})
                .map(Event.onDrinksLoaded)
                .catch { Just(Event.onFailedToLoadDrinks($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

extension FavoritesViewModel {
    enum State {
        case idle([String])
        case loading([String])
        case loaded([ListItem])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectDrink(String)
        case onDrinksLoaded([ListItem])
        case onFailedToLoadDrinks(Error)
    }
    
    struct ListItem: Identifiable, Hashable {
        let id: String
        let title: String
        let thumb: String
        let category: String
        
        init(drink: Drink) {
            id = drink.id
            title = drink.name
            thumb = drink.thumb
            category = drink.category ?? "N/A"
        }
    }
}

extension FavoritesViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle(let favorites):
            switch event {
            case .onAppear:
                return .loading(favorites)
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadDrinks(let error):
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

