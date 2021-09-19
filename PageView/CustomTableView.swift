//
//  CustomTableView.swift
//  PageView
//
//  Created by Indra Tirta Nugraha on 19/09/21.
//

import UIKit

class CustomTableView: UITableView {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
