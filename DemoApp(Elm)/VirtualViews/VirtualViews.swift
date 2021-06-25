import UIKit

public struct ScrollView<A> {
    public let views: [View<A>]
    
    public init(views: [View<A>]) {
        self.views = views
    }
    
    func map<B>(_ transform: @escaping (A) -> B) -> ScrollView<B> {
        return ScrollView<B>(views: views.map { view in view.map(transform) })
    }
}

public struct StackView<A> {
    public let views: [View<A>]
    public let axis: NSLayoutConstraint.Axis
    public let distribution: UIStackView.Distribution
    public let backgroundColor: UIColor
    public let spacing: CGFloat
    public let layoutMargins: UIEdgeInsets
    
    public init(views: [View<A>], axis: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .equalSpacing, backgroundColor: UIColor = .white, spacing: CGFloat = 5.0, layoutMargins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) {
        self.views = views
        self.axis = axis
        self.distribution = distribution
        self.backgroundColor = backgroundColor
        self.spacing = spacing
        self.layoutMargins = layoutMargins
    }
    
    func map<B>(_ transform: @escaping (A) -> B) -> StackView<B> {
        return StackView<B>(views: views.map { view in view.map(transform) }, axis: axis, distribution: distribution, backgroundColor: backgroundColor, spacing: spacing, layoutMargins: layoutMargins)
    }
}

public struct TableView<A> {
    public let items: [TableViewCell<A>]
    
    public init(items: [TableViewCell<A>]) {
        self.items = items
    }
    
    func map<B>(_ transform: @escaping (A) -> B) -> TableView<B> {
        return TableView<B>(items: items.map( { item in item.map(transform) }))
    }
}

public struct TableViewCell<Action> {
    public let text: String
    public let image: UIImage?
    public let category: String
    public let onSelect: Action?
    public let onDelete: Action?
    public init(text: String, onSelect: Action?, image: UIImage?, onDelete: Action?, category: String) {
        self.text = text
        self.image = image
        self.category = category
        self.onSelect = onSelect
        self.onDelete = onDelete
    }
    
    func map<B>(_ transform: @escaping (Action) -> B) -> TableViewCell<B> {
        return TableViewCell<B>(text: text, onSelect: onSelect.map(transform), image: image, onDelete: onDelete.map(transform), category: category)
    }
}

public enum BarButtonItem<Message> {
    case builtin(UIBarButtonItem)
    case system(UIBarButtonItem.SystemItem, action: Message)
    case custom(text: String, action: Message)
    case editButtonItem
    
    func map<B>(_ transform: (Message) -> B) -> BarButtonItem<B> {
        switch self {
        case let .builtin(b):
            return .builtin(b)
        case let .system(i, action: message):
            return .system(i, action: transform(message))
        case let .custom(text: text, action: action):
            return .custom(text: text, action: transform(action))
        case .editButtonItem:
            return .editButtonItem
        }
    }
}

public indirect enum ViewController<Message> {
    case viewController(View<Message>)
    case tableViewController(TableView<Message>)
    case navigationController(NavigationController<Message>)
    
    func map<B>(_ transform: @escaping (Message) -> B) -> ViewController<B> {
        switch self {
        case .navigationController(let nc):
            return .navigationController(nc.map(transform))
        case .tableViewController(let tc):
            return .tableViewController(tc.map(transform))
        case .viewController(let vc):
            return .viewController(vc.map(transform))
        }
    }
}

public struct NavigationController<Message> {
    var viewControllers: [NavigationItem<Message>]
    var back: Message?
    
    public init(viewControllers: [NavigationItem<Message>], back: Message? = nil) {
        self.viewControllers = viewControllers
        self.back = back
    }
    
    public func map<B>(_ transform: @escaping (Message) -> B) -> NavigationController<B> {
        return NavigationController<B>(viewControllers: viewControllers.map { vc in vc.map(transform) }, back: back.map(transform))
    }
}


indirect public enum View<A> {
    case label(text: String)
    case imageView(image: UIImage?)
    case _stackView(StackView<A>)
    case tableView(TableView<A>)
    case scrollView(ScrollView<A>)
    
    func map<B>(_ transform: @escaping (A) -> B) -> View<B> {
        switch self {
        case let .label(text):
            return .label(text: text)
        case let .imageView(image: img):
            return .imageView(image: img)
        case let ._stackView(s):
            return ._stackView(s.map(transform))
        case let .tableView(t):
            return .tableView(t.map(transform))
        case let .scrollView(s):
            return .scrollView(s.map(transform))
        }
    }
}

extension View {
    public static func stackView(views: [View<A>], axis: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .fillProportionally, backgroundColor: UIColor = .white, spacing: CGFloat = 5.0) -> View<A> {
        return ._stackView(StackView(views: views, axis: axis, distribution: distribution, backgroundColor: backgroundColor, spacing: spacing))
    }
    public static func scrollView(views: [View<A>]) -> View<A> {
        return .scrollView(ScrollView(views: views))
    }
}

public struct NavigationItem<Message> {
    let title: String
    let leftBarButtonItem: BarButtonItem<Message>?
    let leftItemsSupplementsBackButton: Bool
    let viewController: ViewController<Message>
    
    public init(title: String = "", leftBarButtonItem: BarButtonItem<Message>? = nil, leftItemsSupplementsBackButton: Bool = false, viewController: ViewController<Message>) {
        self.title = title
        self.leftBarButtonItem = leftBarButtonItem
        self.leftItemsSupplementsBackButton = leftItemsSupplementsBackButton
        self.viewController = viewController
    }
    
    func map<B>(_ transform: @escaping (Message) -> B) -> NavigationItem<B> {
        return NavigationItem<B>(title: title, leftBarButtonItem: leftBarButtonItem?.map(transform), leftItemsSupplementsBackButton: leftItemsSupplementsBackButton, viewController: viewController.map(transform))
    }
}
