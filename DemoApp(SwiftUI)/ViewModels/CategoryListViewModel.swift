//
//  CategoryListViewModel.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 01/05/21.
//

import Combine
import SwiftUI
import Foundation

final class CategoryListViewModel: ObservableObject {
    
    @Published private(set) var state = State.idle
    
    private let service = CategoryListService()
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
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            return self.service.getCategories(.categoryList)
                .map { $0.categories!.map(ListItem.init) }
                .map(Event.onCategoriesLoaded)
                .catch { Just(Event.onFailedToLoadCategories($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

extension CategoryListViewModel {
    enum State {
        case idle
        case loading
        case loaded([ListItem])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onSelectCategory(String)
        case onCategoriesLoaded([ListItem])
        case onFailedToLoadCategories(Error)
    }
    
    struct ListItem: Identifiable {
        let id: UUID
        let title: String
        let poster: String
        
        init(category: Category) {
            id = category.id
            title = category.name
            poster = category.name.formatName()
        }
    }
}

extension CategoryListViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .onAppear:
                return .loading
            default:
                return state
            }
        case .loading:
            switch event {
            case .onFailedToLoadCategories(let error):
                return .error(error)
            case .onCategoriesLoaded(let categories):
                return .loaded(categories)
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
