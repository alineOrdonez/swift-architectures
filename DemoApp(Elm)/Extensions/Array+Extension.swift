//
//  Array+Extension.swift
//  DemoApp(Elm)
//
//  Created by Aline Ordoñez Garcia on 18/06/21.
//

import Foundation

extension Array {
    func last(_ n: Int) -> ArraySlice<Element> {
        return self[endIndex-n..<endIndex]
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

