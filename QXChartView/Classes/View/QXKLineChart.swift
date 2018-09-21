//
//  QXKLineChart.swift
//  QXChartView
//
//  Created by fox on 2018/9/10.
//

import Foundation
import UIKit

public enum QXChartViewScrollPosition {
    case top , end ,none
}

public enum QXChartSelectedPosition {
    case free
    case onClosePrice
}

public protocol QXKLineChartDelegate: class {
    func numberOfPointsInKLineChart(_ chart: QXKLineChartView) -> Int
    
    func kLineChart(_ chart: QXKLineChartView, valueForPointAtIndex: Int) -> QXChartItem
    
    func kLineChart(_ chart: QXKLineChartView, labelOnYAxisForValue value: CGFloat, atIndex index: Int, section
        : QXSection) -> String
    
    func kLineChart(_ chart: QXKLineChartView, labelOnXAxisForValue index: Int) -> String
    
    func didFinishKLineChartRefresh(chart: QXKLineChartView)
    
    func kLineChart(_ chart: QXKLineChartView, decimalAt section: Int) -> Int
    
    func widthForYAxisLabelInKLineChart(in chart:QXKLineChartView) -> CGFloat
    
    func kLineChart(chart: QXKLineChartView, didSelectAt index: Int,item: QXChartItem)
    
    func heightForXAxisInKlineChart(in chart: QXKLineChartView) -> CGFloat
    
    func initRangeInKlineChart(in chart: QXKLineChartView) -> Int
    
    func kLineChart(chart: QXKLineChartView, viewForHeaderInSection section: Int) -> UIView?
    
    func kLineChart(chart: QXKLineChartView, titleForHeaderInsection section: QXSection, index: Int, item: QXChartItem) -> NSAttributedString?
    
    func kLineChart(chart: QXKLineChartView,didFlipPageSeries section: QXSection, series: QXSeries, seriesIndex: Int)
    
    func needsMoreData(chart: QXKLineChartView)
    
}


open class QXKLineChartView:UIView {
    let kMinRange = 13
    let kMaxRange = 133
    let kPerInterval = 4 //缩放的每段间隔
    
    let kYAxisLabelWidth: CGFloat = 46
    let kXAsisLabelHeight: CGFloat = 16
    
    
    @IBInspectable open var upColor : UIColor = UIColor.red

}
