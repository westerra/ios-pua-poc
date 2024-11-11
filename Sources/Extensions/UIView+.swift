//
//  UIView+.swift
//  Copyright © 2023 Westerra CU. All rights reserved.
//

import UIKit

extension UIView {

    class func getAllSubviews<T: UIView>(from parentView: UIView) -> [T] {
        return parentView.subviews.flatMap { subview -> [T] in
            var result = getAllSubviews(from: subview) as [T]
            if let view = subview as? T {
                result.append(view)
            }
            return result
        }
    }

    func getAllSubviews<T: UIView>() -> [T] {
        return UIView.getAllSubviews(from: self) as [T]
    }

    func get<T: UIView>(all type: T.Type) -> [T] {
        return UIView.getAllSubviews(from: self) as [T]
    }
}
