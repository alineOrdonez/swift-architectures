import Foundation
import UIKit

public struct StrongReferences {
    private var handlers: [Any] = []
    
    public init() {}
    
    public mutating func append(_ obj: Any) {
        handlers.append(obj)
    }
    
    mutating func append(contentsOf other: [Any]) {
        handlers.append(contentsOf: other)
    }
}

class TargetAction: NSObject {
    var handle: () -> Void
    init(_ handle: @escaping () -> Void) {
        self.handle = handle
    }
    @objc func performAction(sender: UIButton) {
        handle()
    }
}

final class NCDelegate: NSObject, UINavigationControllerDelegate {
    var back: (() -> Void)
    init(back: @escaping () -> Void) {
        self.back = back
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            back()
        }
        return nil
    }
}

class TextfieldDelegate: NSObject, UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class TableViewBacking<A>: NSObject, UITableViewDataSource, UITableViewDelegate {
    let cells: [TableViewCell<A>]
    let callback: ((A) -> Void)?
    init(cells: [TableViewCell<A>], callback: ((A) -> Void)? = nil) {
        self.cells = cells
        self.callback = callback
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellIdentifier")
        let item = cells[indexPath.row]
        cell.textLabel?.text = item.text
        cell.detailTextLabel?.text = item.category
        cell.imageView?.image = item.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let action = cells[indexPath.row].onDelete {
            callback?(action)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let value = cells[indexPath.row].onSelect {
            callback?(value)
        }
    }
}

extension BarButtonItem {
    func render(_ callback: @escaping (Message) -> Void, viewController: UIViewController, change: inout UIBarButtonItem?) -> [Any] {
        switch self {
        case .builtin(let button):
            if change != button { change = button }
            return []
        case let .custom(text: text, action: action):
            let target = TargetAction { callback(action) }
            change = UIBarButtonItem(title: text, style: .plain, target: target, action: #selector(TargetAction.performAction(sender:)))
            return [target]
        case let .system(item, action: action):
            let target = TargetAction { callback(action) }
            change = UIBarButtonItem(barButtonSystemItem: item, target: target, action: #selector(TargetAction.performAction(sender:)))
            return [target]
            
        case .editButtonItem:
            change = viewController.editButtonItem
            return []
        }
    }
}


public struct Renderer<A> {
    public var strongReferences = StrongReferences()
    private let callback: (A) -> Void
    public init(callback: @escaping (A) -> Void) {
        self.callback = callback
    }
    
    private func render(label text: String, into l: UILabel) {
        l.text = text
        l.backgroundColor = .white
    }
    
    private func render(_ stackView: StackView<A>, into result: UIStackView) {
        result.distribution = stackView.distribution
        result.axis = stackView.axis
        result.backgroundColor = stackView.backgroundColor
    }
    
    public mutating func render(_ tableView: TableView<A>, into result: UITableView) {
        let backing = TableViewBacking(cells: tableView.items, callback: self.callback)
        result.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        result.delegate = backing
        result.dataSource = backing
        strongReferences.append(backing)
        result.reloadData()
    }
    
    public mutating func render(view: View<A>) -> UIView {
        switch view {
        case let .label(text: text):
            let l = UILabel()
            render(label: text, into: l)
            return l
        case let ._stackView(stackView):
            let views = stackView.views.map { render(view: $0) }
            let result = UIStackView(arrangedSubviews: views)
            render(stackView, into: result)
            return result
        case let .imageView(image):
            return UIImageView(image: image)
        case let .tableView(tableView):
            let result = UITableView(frame: .zero, style: .plain)
            render(tableView, into: result)
            return result
        case let .activityIndicator(style):
            let result = UIActivityIndicatorView(style: style)
            result.startAnimating()
            return result
        }
    }
    
    public mutating func update(view: View<A>, into existing: UIView) -> UIView {
        switch view {
        case let .label(text: text):
            guard let l = existing as? UILabel else {
                return render(view: view)
            }
            render(label: text, into: l)
            return l
        case let .activityIndicator(style: style):
            guard let a = existing as? UIActivityIndicatorView else {
                return render(view: view)
            }
            a.style = style
            return a
        case let ._stackView(stackView):
            guard let result = existing as? UIStackView, result.arrangedSubviews.count == stackView.views.count else {
                return render(view: view)
            }
            for (index, existingSubview) in result.arrangedSubviews.enumerated() {
                let sub = stackView.views[index]
                let new = update(view: sub, into: existingSubview)
                if new !== existingSubview {
                    result.removeArrangedSubview(existingSubview)
                    result.insertArrangedSubview(new, at: Int(index))
                }
            }
            render(stackView, into: result)
            return result
        case let .imageView(image):
            guard let result = existing as? UIImageView else {
                return render(view: view)
            }
            result.image = image
            return result
        case let .tableView(tableView):
            guard let result = existing as? UITableView else {
                return render(view: view)
            }
            render(tableView, into: result)
            return result
        }
    }
    
}


extension ViewController {
    public func render(callback: @escaping (Message) -> Void, change: inout UIViewController) -> StrongReferences {
        switch self {
        case let .navigationController(newNC):
            var n: UINavigationController! = change as? UINavigationController
            if n == nil {
                n = UINavigationController()
                change = n
            }
            
            return newNC.render(callback: callback, viewController: n)
        case let .tableViewController(view):
            var t: UITableViewController! = change as? UITableViewController
            if t == nil {
                t = UITableViewController()
                change = t
            }
            var r = Renderer(callback: callback)
            r.render(view, into: t.tableView)
            return r.strongReferences
        case  let .viewController(view):
            var r = Renderer(callback: callback)
            let newView = r.update(view: view, into: change.view)
            if newView !== change.view {
                change.view = newView
            }
            return r.strongReferences
        }
    }
}


extension NavigationItem {
    func render(callback: @escaping (Message) -> Void, viewController: inout UIViewController) -> StrongReferences {
        var strongReferences = self.viewController.render(callback: callback, change: &viewController)
        let ni = viewController.navigationItem
        strongReferences.append(leftBarButtonItem?.render(callback, viewController: viewController, change: &ni.leftBarButtonItem) ?? [])
        ni.leftItemsSupplementBackButton = leftItemsSupplementsBackButton
        ni.title = title
        return strongReferences
    }
}

extension NavigationController {
    func render(callback: @escaping (Message) -> Void, viewController nc: UINavigationController) -> StrongReferences {
        var strongReferences = StrongReferences()
        if let back = back {
            let delegate = NCDelegate {
                callback(back)
            }
            nc.delegate = delegate
            strongReferences.append(delegate)
        }
        let diffN = viewControllers.count - nc.viewControllers.count
        if diffN < 0 {
            nc.viewControllers.removeLast(diffN)
        }
        for (v, index) in zip(viewControllers, nc.viewControllers.indices) {
            strongReferences.append(v.render(callback: callback, viewController: &nc.viewControllers[index]))
        }
        
        
        if diffN > 0 {
            for v in viewControllers.last(diffN) {
                var vc = UIViewController()
                strongReferences.append(v.render(callback: callback, viewController: &vc))
                nc.pushViewController(vc, animated: true)
            }
        }
        return strongReferences
        
    }
}
