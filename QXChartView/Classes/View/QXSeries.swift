//
//  QXSeries.swift
//  QXChartView
//
//  Created by fox on 2018/8/15.
//

import Foundation
import UIKit

public struct QXSeriesKey {
    public static let candle = "Candle"
    public static let timeline = "Timeline"
    public static let volume = "Volume"
    public static let ma = "MA"
    public static let ema = "EMA"
    public static let kdj = "KDJ"
    public static let macd = "MACD"
    public static let boll = "BOLL"
    public static let sar = "SAR"
    public static let sam = "SAM"
    public static let rsi = "RSI"
}


open class QXSeries: NSObject {
    open var key = ""
    open var title = ""
    open var chartModels = [QXChartModel]()
    open var hidden = false
    open var showTitle = true
    open var baseValueSticky = false
    open var symmetrical = false
    
    var seriesLayer: QXShapeLayer = QXShapeLayer()
    
    public var algorithms = [Any]()
    
    func removeLayerView() {
        _ = self.seriesLayer.sublayers?.map{$0.removeFromSuperlayer()}
        self.seriesLayer.sublayers?.removeAll()
    }
}

extension QXSeries {
    public class func getTimelinePrice(color: UIColor,section: QXSection,showGuide: Bool = true, ultimateValueStyle: QXUltimateValueStyle = .none, lineWidth: CGFloat = 1) -> QXSeries {
        let series = QXSeries()
        series.key = QXSeriesKey.timeline
        let timeline = QXChartModel.getLine(color, title: "price", key: "\(QXSeriesKey.timeline)_\(QXSeriesKey.timeline)")
        timeline.section = section
        timeline.useTitleColor = false
        timeline.ultimateValueStyle = ultimateValueStyle
        timeline.showMaxVal = showGuide
        timeline.showMinVal = showGuide
        timeline.lineWidth = lineWidth
        series.chartModels = [timeline]
        return series
    }
    
    /**
     返回一个标准的蜡烛柱价格系列样式
     */
    public class func getCandlePrice(upStyle: (color: UIColor, isSolid: Bool),
                                     downStyle: (color: UIColor, isSolid: Bool),
                                     titleColor: UIColor,
                                     section: QXSection,
                                     showGuide: Bool = false,
                                     ultimateValueStyle: QXUltimateValueStyle = .none) -> QXSeries {
        let series = QXSeries()
//        series.key = QXSeriesKey.candle
//        let candle = QXChartModel.getCandle(upStyle: upStyle, downStyle: downStyle, titleColor: titleColor)
//        candle.section = section
//        candle.useTitleColor = false
//        candle.showMaxVal = showGuide
//        candle.showMinVal = showGuide
//        candle.ultimateValueStyle = ultimateValueStyle
//        series.chartModels = [candle]
        return series
    }
}
