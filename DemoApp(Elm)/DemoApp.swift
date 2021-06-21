//
//  DemoApp.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 17/06/21.
//

struct Todo {
    var title: String
    var done: Bool
}

struct List {
    var title: String
    var items: [Todo]
}

public struct DemoApp {
    var lists: [List]
    var selectedListIndex: Int?
    
    public init() {
        lists = []
        selectedListIndex = nil
    }
}

extension List {
    var tableView: TableView<DemoApp.Message> {
        let cells: [TableViewCell<DemoApp.Message>] = items.enumerated().map { el in
            let (index, todo) = el
            return TableViewCell<DemoApp.Message>(text: todo.title, onSelect: DemoApp.Message.toggleDone(index: index), accessory: todo.done ? .checkmark: .none, onDelete: nil)
        }
        return TableView<DemoApp.Message>(items: cells)
    }
}

extension Array where Element == List {
    var tableViewController: ViewController<DemoApp.Message> {
        let cells: [TableViewCell<DemoApp.Message>] = zip(self, self.indices).map { (el) in
            let (item, index) = el
            return TableViewCell(text: item.title, onSelect: .select(listIndex: index), onDelete: .delete(listIndex: index))
        }
        return ViewController.tableViewController(TableView(items: cells))
    }
}

extension DemoApp: Component {
    
    public enum Message {
        case back
        case select(listIndex: Int)
        case addList
        case addItem
        case createList(String?)
        case createItem(String?)
        case delete(listIndex: Int)
        case toggleDone(index: Int)
    }
    
    var selectedList: List? {
        get {
            guard let i = selectedListIndex else { return nil }
            return lists[i]
        }
        set {
            guard let i = selectedListIndex, let value = newValue else { return }
            lists[i] = value
        }
    }
    
    public var viewController: ViewController<Message> {
        let addList: BarButtonItem<Message> = BarButtonItem.system(.add, action: .addList)
        
        var viewControllers: [NavigationItem<Message>] = [
            NavigationItem(title: "Todos", leftBarButtonItem: nil, rightBarButtonItems: [addList], viewController: lists.tableViewController)
        ]
        if let list = selectedList {
            viewControllers.append(NavigationItem(title: list.title, rightBarButtonItems: [.system(.add, action: .addItem)], viewController: .tableViewController(list.tableView)))
        }
        return ViewController.navigationController(NavigationController(viewControllers: viewControllers, back: .back))
    }
    
    mutating public func send(_ msg: Message) -> [Command<Message>] {
        switch msg {
        case .addList:
            return [
                .modalTextAlert(title: "Add List",
                                accept: "OK",
                                cancel: "Cancel",
                                convert: { .createList($0) })]
        case .addItem:
            
            return [
                .modalTextAlert(title: "Add Item",
                                accept: "OK",
                                cancel: "Cancel",
                                convert: { .createItem($0) })]
            
        case .createList(let title):
            guard let title = title else { return [] }
            lists.append(List(title: title, items: []))
            return []
        case .createItem(let title):
            guard let title = title else { return [] }
            selectedList?.items.append(Todo(title: title, done: false))
            return []
        case .select(listIndex: let index):
            selectedListIndex = index
            return []
        case .back:
            selectedListIndex = nil
            return []
        case .delete(listIndex: let index):
            lists.remove(at: index)
            return []
        case .toggleDone(index: let index):
            guard let i = selectedListIndex else { return [] }
            lists[i].items[index].done = !lists[i].items[index].done
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
