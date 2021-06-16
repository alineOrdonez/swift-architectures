//
//  VirtualViews.swift
//  DemoApp(Elm)
//
//  Created by Aline Arely Ordonez Garcia on 08/06/21.
//

import UIKit

struct TableView<Message> {
    let items: [TableViewCell<Message>]
    
    init(items: [TableViewCell<Message>]) {
        self.items = items
    }
    
    func map<B>(_ transform: @escaping (Message) -> B) -> TableView<B> {
        return TableView<B>(items: items.map({ item in item.map(transform) }))
    }
}

struct TableViewCell<Message> {
    let id: String
    let text: String
    let onSelect: Message?
    let accessory: UITableViewCell.AccessoryType
    
    init(id: String, text: String, onSelect: Message?, accessory: UITableViewCell.AccessoryType = .none) {
        self.id = id
        self.text = text
        self.accessory = accessory
        self.onSelect = onSelect
    }
    
    static func ==(lhs: TableViewCell<Message>, rhs: TableViewCell<Message>) -> Bool {
        return lhs.id == rhs.id && lhs.text == rhs.text && lhs.accessory == rhs.accessory
    }
    
    func map<B>(_ transform: @escaping (Message) -> B) -> TableViewCell<B> {
        return TableViewCell<B>(id: id, text: text, onSelect: onSelect.map(transform))
    }
}

struct Button<Message> {
    let text: String
    let onTap: Message?
    
    init(text: String, onTap: Message? = nil) {
        self.text = text
        self.onTap = onTap
    }
    
    func map<B>(_ transform: (Message) -> B) -> Button<B> {
        return Button<B>(text: text, onTap: onTap.map(transform))
    }
}
