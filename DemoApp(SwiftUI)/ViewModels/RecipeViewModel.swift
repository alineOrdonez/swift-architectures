//
//  RecipeViewModel.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 07/06/21.
//

import Foundation
import Combine
import SwiftUI

final class RecipeViewModel: ObservableObject {
    
    @Published private(set) var state: State
    
    private let service = RecipeService()
    private var bag = Set<AnyCancellable>()
    private let input = PassthroughSubject<Event, Never>()
    
    init(id: String) {
        state = .idle(id)
        
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
            guard case .loading(let id) = state else { return Empty().eraseToAnyPublisher() }
            
            return self.service.getRecipe(.drink(id))
                .map({ drinks in
                    let drink = drinks.drinks![0]
                    return Item(drink)
                })
                .map(Event.onRecipeLoaded)
                .catch { Just(Event.onFailedToLoadRecipe($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}

extension RecipeViewModel {
    enum State {
        case idle(String)
        case loading(String)
        case loaded(Item)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onRecipeLoaded(Item)
        case onFailedToLoadRecipe(Error)
    }
    
    struct Item: Identifiable, Hashable {
        let id: String
        let title: String
        let video: String?
        let thumb: String
        var ingredients: [[String: String]]?
        let glass: String
        let instructions: String
        
        init(_ drink: Drink) {
            id = drink.id
            title = drink.name
            video = drink.video
            thumb = drink.thumb
            glass = drink.glass ?? ""
            instructions = drink.instructions ?? ""
            ingredients = addIngredientes(drink)
        }
        
        func addIngredientes(_ drink: Drink) -> [[String: String]] {
            let ingredients: [String] = [drink.strIngredient1, drink.strIngredient2, drink.strIngredient3, drink.strIngredient4, drink.strIngredient5, drink.strIngredient6, drink.strIngredient7].compactMap({$0}).filter({ !$0.isEmpty })
            
            let measures: [String] = [drink.strMeasure1, drink.strMeasure2, drink.strMeasure3, drink.strMeasure4, drink.strMeasure5, drink.strMeasure6, drink.strMeasure7].compactMap { measure in
                guard let measure = measure, !measure.isEmpty else {
                    return "-"
                }
                return measure
            }
            var array = [[String: String]]()
            
            for (index, element) in ingredients.enumerated() {
                let dictionary = [element: measures[index]]
                array.append(dictionary)
            }
            return array
        }
    }
}

extension RecipeViewModel {
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
            case .onFailedToLoadRecipe(let error):
                return .error(error)
            case .onRecipeLoaded(let drinks):
                return .loaded(drinks)
            default:
                return state
            }
        case .loaded(_):
            return state
        case .error(let error):
            print(error)
            return state
        }
    }
}
