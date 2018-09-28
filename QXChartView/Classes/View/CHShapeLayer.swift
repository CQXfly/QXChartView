//
//  CHShapeLayer.swift
//  QXChartView
//
//  Created by fox on 2018/8/15.
//

import Foundation
import UIKit


open class QXShapeLayer: CAShapeLayer {
    open override func action(forKey event: String) -> CAAction? {
        return nil
    }
}

open class QXTextLayer: CATextLayer {
    open override func action(forKey event: String) -> CAAction? {
        return nil
    }
}
