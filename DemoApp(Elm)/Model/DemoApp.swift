//
//  DemoApp.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 17/06/21.
//
import UIKit

struct Drink: Identifiable, Codable {
    let id: String
    let name: String
    let category: String
    let thumb: String
    var image: UIImage?
    let instructions: String
    let ingredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case thumb = "strDrinkThumb"
        case instructions = "strInstructions"
        case ingredients = "strIngredients"
    }
}

struct Ingredient: Codable {
    let name: String
    let measure: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strIngredient"
        case measure = "strMeasure"
    }
}

struct DrinkList: Codable {
    let drinks: [Drink]?
}

public struct DemoApp {
    var lists: [Drink]
    var selectedIndex: Int?
    var loading: Bool = false
    
    public init() {
        lists = []
        selectedIndex = nil
    }
}

extension Array where Element == Drink {
    var tableViewController: ViewController<DemoApp.Message> {
        let cells: [TableViewCell<DemoApp.Message>] = zip(self, self.indices).map { (element) in
            let (item, index) = element
            return TableViewCell(text: item.name, onSelect: .select(listIndex: index), image: item.image, onDelete: .delete(listIndex: index), category: item.category)
        }
        return ViewController.tableViewController(TableView(items: cells))
    }
}

extension DemoApp: Component {
    
    static var Spacer: String {
        return "\n\n"
    }
    
    static var findURL: URL {
        return URL(string: "https://1e7ef212-6cca-41a5-9495-9d473fd35cc0.mock.pstmn.io/getFavorites")!
    }
    
    public enum Message {
        case back
        case receivedData(Data?)
        case downloadImage(Int, Data)
        case select(listIndex: Int)
        case delete(listIndex: Int)
    }
    
    var selectedItem: Drink? {
        get {
            guard let i = selectedIndex else { return nil }
            return lists[i]
        }
        set {
            guard let i = selectedIndex, let value = newValue else { return }
            lists[i] = value
        }
    }
    
    public var viewController: ViewController<Message> {
        
        var viewControllers: [NavigationItem<Message>] = [
            NavigationItem(title: "Favorite Drinks", leftBarButtonItem: nil, viewController: lists.tableViewController)
        ]
        if let item = selectedItem {
            let viewDetail: View<Message> = .stackView(views: viewDetail, distribution: .equalSpacing, spacing: 8.0)
            viewControllers.append(NavigationItem(title: item.name, leftBarButtonItem: nil, viewController: .viewController(viewDetail)))
        }
        return ViewController.navigationController(NavigationController(viewControllers: viewControllers, back: .back))
    }
    
    private var viewDetail: [View<Message>] {
        var elements: [View<Message>] = []
        if let item = selectedItem {
            elements = [.imageView(image: item.image), .label(Label(text: "Ingredients:", font: UIFont.boldSystemFont(ofSize: 16)))]
            
            for ingredient in item.ingredients {
                elements.append(.stackView(views: [.label(Label(text: ingredient.name)), .label(Label(text: ingredient.measure))], axis: .horizontal, distribution: .fillEqually))
            }
            elements.append(.label(Label(text: "Instructions:", font: UIFont.boldSystemFont(ofSize: 16), numberOfLines: 1)))
            elements.append(.label(Label(text: item.instructions)))
            elements.append(.label(Label(text: Self.Spacer)))
        }
        return elements
    }
    
    mutating public func send(_ msg: Message) -> [Command<Message>] {
        switch msg {
        case .receivedData(let data):
            guard let validData = data else {
                return []
            }
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(DrinkList.self, from: validData)
                
                guard let drinks = decoded.drinks else {
                    return []
                }
                lists = drinks
            } catch(let error) {
                print(error)
                return []
            }
            var commands: [Command<Message>] = []
            for (index, element) in lists.enumerated() {
                let url = URL(string: element.thumb)!
                commands.append(.request(URLRequest(url: url), available: {.downloadImage(index, $0!)}))
            }
            return commands
        case .downloadImage(let index, let data):
            lists[index].image = UIImage(data: data)
            return []
        case .select(listIndex: let index):
            selectedIndex = index
            return []
        case .back:
            selectedIndex = nil
            return []
        case .delete(listIndex: let index):
            lists.remove(at: index)
            return []
        }
    }
}

extension DemoApp.Message: Equatable {
    public static func ==(lhs: DemoApp.Message, rhs: DemoApp.Message) -> Bool {
        switch (lhs, rhs) {
        case (.back, .back): return true
        case (.select(let l), .select(let r)): return l == r
        default: return false
        }
    }
}
