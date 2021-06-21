import UIKit

public struct Button<Action> {
    public let text: String
    public let onTap: Action?
    
    public init(text: String, onTap: Action? = nil) {
        self.text = text
        self.onTap = onTap
    }
    
    func map<B>(_ transform: (Action) -> B) -> Button<B> {
        return Button<B>(text: text, onTap: onTap.map(transform))
    }
}

public struct TextField<Action> {
    public let text: String
    public let onChange: ((String?) -> Action)?
    
    
    public init(text: String, onChange: ((String?) -> Action)? = nil) {
        self.text = text
        self.onChange = onChange
    }
    
    func map<B>(_ transform: @escaping (Action) -> B) -> TextField<B> {
        return TextField<B>(text: text, onChange: onChange.map { x in { transform(x($0)) } })
    }
}

public struct StackView<A> {
    public let views: [View<A>]
    public let axis: NSLayoutConstraint.Axis
    public let distribution: UIStackView.Distribution
    public let backgroundColor: UIColor
    public init(views: [View<A>], axis: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .equalCentering, backgroundColor: UIColor = .white) {
        self.views = views
        self.axis = axis
        self.distribution = distribution
        self.backgroundColor = backgroundColor
    }
    
    func map<B>(_ transform: @escaping (A) -> B) -> StackView<B> {
        return StackView<B>(views: views.map { view in view.map(transform) }, axis: axis, distribution: distribution, backgroundColor: backgroundColor)
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
    public let onSelect: Action?
    public let onDelete: Action?
    public let accessory: UITableViewCell.AccessoryType
    public init(text: String, onSelect: Action?, accessory: UITableViewCell.AccessoryType = .none, onDelete: Action?) {
        self.text = text
        self.accessory = accessory
        self.onSelect = onSelect
        self.onDelete = onDelete
    }
    
    func map<B>(_ transform: @escaping (Action) -> B) -> TableViewCell<B> {
        return TableViewCell<B>(text: text, onSelect: onSelect.map(transform), onDelete: onDelete.map(transform))
    }
}

public struct Slider<Action> {
    public let progress: Float
    public let max: Float
    public let onChange: ((Float) -> Action)?
    public init(progress: Float, max: Float = 1, onChange: ((Float) -> Action)? = nil) {
        self.progress = progress
        self.max = max
        self.onChange = onChange
    }
    
    func map<B>(_ transform: @escaping (Action) -> B) -> Slider<B> {
        return Slider<B>(progress: progress, max: max, onChange: onChange.map { o in { value in transform(o(value)) } })
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
        case .navigationController(let nc): return .navigationController(nc.map(transform))
        case .tableViewController(let tc): return .tableViewController(tc.map(transform))
        case .viewController(let vc): return .viewController(vc.map(transform))
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
    case _button(Button<A>)
    case _textfield(TextField<A>)
    case label(text: String)
    case imageView(image: UIImage?)
    case _stackView(StackView<A>)
    case _slider(Slider<A>)
    case tableView(TableView<A>)
    case activityIndicator(style: UIActivityIndicatorView.Style)
    
    func map<B>(_ transform: @escaping (A) -> B) -> View<B> {
        switch self {
        case ._button(let b):
            return ._button(b.map(transform))
        case ._textfield(let t):
            return ._textfield(t.map(transform))
        case let .label(text):
            return .label(text: text)
        case let .imageView(image: img):
            return .imageView(image: img)
        case let ._stackView(s):
            return ._stackView(s.map(transform))
        case let ._slider(s):
            return ._slider(s.map(transform))
        case let .tableView(t):
            return .tableView(t.map(transform))
        case let .activityIndicator(style):
            return .activityIndicator(style: style)
        }
    }
}

extension View {
    public static func stackView(views: [View<A>], axis: NSLayoutConstraint.Axis = .vertical, distribution: UIStackView.Distribution = .equalCentering, backgroundColor: UIColor = .white) -> View<A> {
        return ._stackView(StackView(views: views, axis: axis, distribution: distribution, backgroundColor: backgroundColor))
    }
    
    public static func button(text: String, onTap: A? = nil) -> View<A> {
        return ._button(Button(text: text, onTap: onTap))
    }
    
    public static func slider(progress: Float, max: Float = 1, onChange: ((Float) -> A)? = nil) -> View<A> {
        return ._slider(Slider(progress: progress, max: max, onChange: onChange))
    }
    
    public static func textField(text: String, onChange: ((String?) -> A)? = nil) -> View<A> {
        return ._textfield(TextField(text: text, onChange: onChange))
    }
}

public struct Modal<Message> {
    let viewController: ViewController<Message>
    let presentationStyle: UIModalPresentationStyle
    
    func map<B>(_ transform: @escaping (Message) -> B) -> Modal<B> {
        return Modal<B>(viewController: viewController.map(transform), presentationStyle: presentationStyle)
    }
}

public struct NavigationItem<Message> {
    let title: String
    let leftBarButtonItem: BarButtonItem<Message>?
    let rightBarButtonItems: [BarButtonItem<Message>]
    let leftItemsSupplementsBackButton: Bool
    let viewController: ViewController<Message>
    
    public init(title: String = "", leftBarButtonItem: BarButtonItem<Message>? = nil, rightBarButtonItems: [BarButtonItem<Message>] = [], leftItemsSupplementsBackButton: Bool = false, viewController: ViewController<Message>) {
        self.title = title
        self.leftBarButtonItem = leftBarButtonItem
        self.rightBarButtonItems = rightBarButtonItems
        self.leftItemsSupplementsBackButton = leftItemsSupplementsBackButton
        self.viewController = viewController
    }
    
    func map<B>(_ transform: @escaping (Message) -> B) -> NavigationItem<B> {
        return NavigationItem<B>(title: title, leftBarButtonItem: leftBarButtonItem?.map(transform), rightBarButtonItems: rightBarButtonItems.map { btn in btn.map(transform) }, leftItemsSupplementsBackButton: leftItemsSupplementsBackButton, viewController: viewController.map(transform))
    }
}
