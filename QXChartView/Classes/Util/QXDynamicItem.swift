//
//  QXDynamicItem.swift
//  QXChartView
//
//  Created by fox on 2018/9/21.
//

import UIKit

class QXDynamicItem: NSObject, UIDynamicItem {
    var center: CGPoint = .zero
    var bounds: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
    var transform: CGAffineTransform = CGAffineTransform.identity
}
