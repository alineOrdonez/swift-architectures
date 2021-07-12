//
//  CategoryDetailViewModel.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 02/05/21.
//

import Foundation
import Combine
import SwiftUI

final class CategoryDetailViewModel: ObservableObject {
    
    @Published private(set) var state: State
    
    private let service = CategoryDetailService()
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    @AppStorage("favorites") var favorites: [String] = []
    
    init(name: String) {
        state = .idle(name)
        
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
            guard case .loading(let name) = state else { return Empty().eraseToAnyPublisher() }
            
            return self.service.getDrinks(.drinksIn(name))
                .map { $0.drinks!.map(ListItem.init) }
                .map(Event.onDrinksLoaded)
                .catch { Just(Event.onFailedToLoadDrinks($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
    
    func shouldAddToFavorites(_ current: ListItem) -> Bool {
        if let _ = favorites.firstIndex(where: {$0 == current.id}) {
            return true
        }
        return false
    }
    
    func addOrRemove(_ current: ListItem) {
        if let index = favorites.firstIndex(where: {$0 == current.id}) {
            favorites.remove(at: index)
        } else {
            favorites.append(current.id)
        }
    }
}

extension CategoryDetailViewModel {
    enum State {
        case idle(String)
        case loading(String)
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
        
        init(category: Drink) {
            id = category.id
            title = category.name
            thumb = category.thumb
        }
    }
}

extension CategoryDetailViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle(let name):
            switch event {
            case .onAppear:
                return .loading(name)
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
