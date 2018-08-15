//
//  QXKlineChartStyle.swift
//  QXChartView
//
//  Created by fox on 2018/8/15.
//

import Foundation


/// 最大值最小值的显示风格
///
/// - none: 不显示
/// - arrow: 箭头风格
/// - circle: 空心圆风格
/// - tag: 标签风格
public enum QXUltimateValueStyle {
    case none
    case arrow(UIColor)
    case circle(UIColor,Bool)
    case tag(UIColor)
}
