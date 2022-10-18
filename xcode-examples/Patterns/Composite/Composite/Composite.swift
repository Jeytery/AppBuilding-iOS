//
//  Composite.swift
//  Composite
//
//  Created by Jeytery on 17.10.2022.
//

import Foundation
import UIKit

//MARK: - theme
protocol Theme: CustomStringConvertible {
    var backgroundColor: UIColor { get }
}

protocol ButtonTheme: Theme {
    var textColor: UIColor { get set }
    var highlightedColor: UIColor { get set }
    var description: String { get set }
}

//MARK: - component
protocol Component {
    func accept<T: Theme>(theme: T)
}

extension Component where Self: UIView {
    func accept<T: Theme>(theme: T) {
        backgroundColor = theme.backgroundColor
    }
}

extension Component where Self: UIViewController {
    func accept<T: Theme>(theme: T) {
        view.accept(theme: theme)
        view.subviews.forEach { $0.accept(theme: theme) }
    }
}

extension Component where Self: UIButton {
    func accept<T: ButtonTheme>(theme: T) {
        backgroundColor = theme.backgroundColor
        setTitleColor(theme.textColor, for: .normal)
        setTitleColor(theme.highlightedColor, for: .highlighted)
    }
}

extension UIView: Component {}
extension UIViewController: Component {}

//MARK: - usage
struct DefaultButtonTheme: ButtonTheme {
    var textColor = UIColor.red
    var highlightedColor = UIColor.white
    var backgroundColor = UIColor.orange
    var description: String = "Def button theme"
}

struct NightButtonTheme: ButtonTheme {
    var textColor = UIColor.white
    var highlightedColor = UIColor.red
    var backgroundColor = UIColor.black
    var description: String = "Night Buttom Theme"
}
