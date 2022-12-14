//
//  UITableView+Ext.swift
//  
//
//  Created by huawt on 2022/11/7.
//

import Foundation
import UIKit

extension UITableView {
    @objc func modifySwipe(fontSize: CGFloat = 10) {
        guard let font: UIFont = UIFont(name: "PingFangSC-Medium", size: fontSize) else { return }
        if #available(iOS 13.0, *) {
            for subview in self.subviews {
                if NSStringFromClass(type(of: subview)) == "_UITableViewCellSwipeContainerView" {
                    for swipeContainerSubview in subview.subviews {
                        if NSStringFromClass(type(of: swipeContainerSubview)) == "UISwipeActionPullView" {
                            for case let button as UIButton in swipeContainerSubview.subviews {
                                button.titleLabel?.font = font
                            }
                        }
                    }
                }
            }
        } else {
            for subview in self.subviews {
                if NSStringFromClass(type(of: subview)) == "UISwipeActionPullView" {
                    for case let button as UIButton in subview.subviews {
                        button.titleLabel?.font = font
                    }
                }
            }
        }
        
    }
}
