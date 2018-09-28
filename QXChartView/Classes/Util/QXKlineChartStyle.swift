//
//  QXKlineChartStyle.swift
//  QXChartView
//
//  Created by fox on 2018/8/15.
//

import UIKit


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


open class QXKLineChartStyle {
    open var sections: [QXSection] = [QXSection]()
    
    open var algorithms: [QXChartAlgorithmProtocol] = []
    
    open var backgroundColor = UIColor.white
    
    open var borderWidth: (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) = (0.5, 0.5, 0.5, 0.5)
    
    open var padding: UIEdgeInsets!
    
    open var labelFont: UIFont!
    
    open var lineColor = UIColor.clear
    
    open var textColor = UIColor.clear
    
    open var selectedBGColor = UIColor.clear
    
    open var selectedTextColor = UIColor.clear
    
    open var showYAxisLabel = QXYAxisShowPosition.right
    
    open var isInnerYAxis: Bool = false
    
    //是否可缩放
    open var enablePinch: Bool = true
    //是否可滑动
    open var enablePan: Bool = true
    //是否可点选
    open var enableTap: Bool = true
    
    /// 是否显示选中的内容
    open var showSelection: Bool = true
    
    /// 把X坐标内容显示到哪个索引分区上，默认为-1，表示最后一个，如果用户设置溢出的数值，也以最后一个
    open var showXAxisOnSection: Int = -1
    
    /// 是否显示X轴标签
    open var showXAxisLabel: Bool = true
    
    /// 是否显示所有内容
    open var isShowAll: Bool = false
    
    /// 买方深度图层颜色
    open var bidColor: (stroke: UIColor, fill: UIColor, lineWidth: CGFloat) = (.white, .white, 1)
    
    /// 卖方深度图层颜色
    open var askColor: (stroke: UIColor, fill: UIColor, lineWidth: CGFloat) = (.white, .white, 1)
    
    /// 买单居右
//    open var bidChartOnDirection:CHKDepthChartOnDirection = .right
    
    public init() {
        
    }
}

extension QXKLineChartStyle {
    public static var base: QXKLineChartStyle {
        let style = QXKLineChartStyle()
        
        style.labelFont = UIFont.systemFont(ofSize: 10)
        style.lineColor = UIColor(white: 0.2, alpha: 1)
        style.textColor = UIColor(white: 0.8, alpha: 1)
        style.selectedBGColor = UIColor(white: 0.4, alpha: 1)
        style.selectedTextColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        style.padding = UIEdgeInsets(top: 32, left: 8, bottom: 4, right: 0)
        style.backgroundColor = UIColor.qx_hex(0x1D1C1C)
        style.showYAxisLabel = .right
        
        style.algorithms = [
            QXChartAlgorithm.timeline
        ]
        
        let upcolor = (UIColor.qx_hex(0x1E932B), true)
        let downcolor = (UIColor.qx_hex(0xF80D1F), true)
        let priceSection = QXSection()
        priceSection.backgroundColor = style.backgroundColor
        priceSection.titleShowOutSide = true
        priceSection.valueType = .master
        priceSection.key = "master"
        priceSection.hidden = false
        priceSection.ratios = 3
        priceSection.padding = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        
        let timelineSeries = QXSeries.getTimelinePrice(
            color:  UIColor.qx_hex(0xAE475C),
            section: priceSection,
            showGuide: true,
            ultimateValueStyle: .circle(UIColor.qx_hex(0xAE475C), true),
            lineWidth: 2)
        
        timelineSeries.hidden = true
        
//        /// 蜡烛线
//        let priceSeries = QXSeries.getCandlePrice(
//            upStyle: upcolor,
//            downStyle: downcolor,
//            titleColor: UIColor(white: 0.8, alpha: 1),
//            section: priceSection,
//            showGuide: true,
//            ultimateValueStyle: .arrow(UIColor(white: 0.8, alpha: 1)))
//
//        priceSeries.showTitle = true
//
//        priceSeries.chartModels.first?.ultimateValueStyle = .arrow(UIColor(white: 0.8, alpha: 1))
        
        style.sections = [priceSection]
        
        return style
    }
}
