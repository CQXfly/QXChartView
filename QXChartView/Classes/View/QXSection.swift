//
//  QXSection.swift
//  QXChartView
//
//  Created by fox on 2018/8/15.
//

import Foundation

public enum QXSectionValueType {
    case master
    case assistant
}

open class QXSection {
    open var upColor:UIColor = UIColor.red
    open var downColor: UIColor = UIColor.green
    open var titleColor: UIColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    open var labelFont = UIFont.systemFont(ofSize: 10)
    open var valueType: QXSectionValueType = QXSectionValueType.master
    
    open var key = ""
    open var name: String = ""
    
    open var hidden: Bool = false
    open var paging: Bool = false
    open var selectedIndex: Int = 0
    open var padding: UIEdgeInsets = UIEdgeInsets.zero
    open var series = [QXSeries]()
    
    open var tickInterval: Int = 0
    open var title: String = ""
    
    open var titleShowOutSide: Bool = false
    
    open var showTitle: Bool = true
    
    open var decimal: Int = 2
    
    /// 所占区域比例
    open var ratios: Int = 0
    //固定高度，为0则通过ratio计算高度
    open var fixHeight: CGFloat = 0
    
    open var frame: CGRect = CGRect.zero
    /// Y轴参数
    open var yAxis: QXYAxis = QXYAxis()
    // X轴参数
    open var xAxis: QXXAxis = QXXAxis()
    
    open var backgroundColor: UIColor = .black
    
    open var index: Int = 0
    
    var titleLayer: QXShapeLayer = QXShapeLayer()
    
    var sectionLayer: QXShapeLayer = QXShapeLayer()
    
    var titleView: UIView?
    
}

extension QXSection {
    public func getLocalY(_ val: CGFloat) -> CGFloat {
        let max = self.yAxis.max
        let min = self.yAxis.min
        
        if (max == min) {
            return 0
        }
        
        
        /*
         计算公式：
         y轴有值的区间高度 = 整个分区高度-（paddingTop+paddingBottom）
         当前y值所在位置的比例 =（当前值 - y最小值）/（y最大值 - y最小值）
         当前y值的实际的相对y轴有值的区间的高度 = 当前y值所在位置的比例 * y轴有值的区间高度
         当前y值的实际坐标 = 分区高度 + 分区y坐标 - paddingBottom - 当前y值的实际的相对y轴有值的区间的高度
         */
        
        let baseY = self.frame.size.height + self.frame.origin.y - self.padding.bottom - (self.frame.size.height - self.padding.top - self.padding.bottom) * (val - min) / (max - min)
        
        return baseY
    }
}
