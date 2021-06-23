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
    
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case thumb = "strDrinkThumb"
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
    
    static var findURL: URL {
        return URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=coffee")!
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
            viewControllers.append(NavigationItem(title: item.name, leftBarButtonItem: nil, viewController: .viewController(.label(text: item.name))))
        }
        return ViewController.navigationController(NavigationController(viewControllers: viewControllers, back: .back))
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
            } catch {
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
    
    public var subscriptions: [Subscription<Message>] {
        return []
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
