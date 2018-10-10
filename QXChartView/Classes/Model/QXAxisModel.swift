//
//  QXAxisModel.swift
//  QXChartView
//
//  Created by fox on 2018/8/15.
//

import UIKit
/**
 Y轴显示的位置
 
 - Left:  左边
 - Right: 右边
 - None:  不显示
 */
public enum QXYAxisShowPosition {
    case left, right, none
}


/// 坐标轴辅助线样式风格
///
/// - none: 不显示
/// - dash: 虚线
/// - solid: 实线
public enum QXAxisAssistLineStyle {
    case none
    case dash(color: UIColor, pattern: [NSNumber])
    case solid(color: UIColor)
}

public struct QXYAxis {
    /// Y轴最大值
    public var max: CGFloat = 0
    
    /// Y轴最小值
    public var min: CGFloat = 0
    
    /// 上下边界溢出值的比例
    public var ext: CGFloat = 0.00
    
    /// 固定的基值
    public var baseValue: CGFloat = 0

    /// 间断显示个数
    public var tickInterval: Int = 4
    
    public var pos: Int = 0
    /// 约束小数位
    public var decimal: Int = 2
    
    public var isUsed = false
    
    /// 辅助线样式
    public var assistLineStyle: QXAxisAssistLineStyle = .dash(color: UIColor(white: 0.2, alpha: 1), pattern: [5])
}




/// X轴
public struct QXXAxis {
    
    public var tickInterval: Int = 6           //间断显示个数
    
    /// 辅助线样式
    public var assistLineStyle: QXAxisAssistLineStyle = .none
}
