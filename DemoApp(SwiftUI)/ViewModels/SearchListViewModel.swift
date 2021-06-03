//
//  SearchListViewModel.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 03/06/21.
//

import Foundation
import Combine
import SwiftUI

final class SearchListViewModel: ObservableObject {
    
    @Published private(set) var state = State.idle
    
    private let service = SearchService()
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
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
            guard case .loading(let drink) = state else { return Empty().eraseToAnyPublisher() }
            
            return self.service.searchRecipe(.search(drink))
                .map { $0.drinks!.map(ListItem.init) }
                .map(Event.onDrinksLoaded)
                .catch { Just(Event.onFailedToLoadDrinks($0)) }
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
        case loading(String)
        case loaded([ListItem])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onDidChange(String)
        case onCancel
        case onSelectDrink(String)
        case onDrinksLoaded([ListItem])
        case onFailedToLoadDrinks(Error)
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
            switch event {
            case .onDidChange(let drink):
                return .loading(drink)
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
