//
//  QXChartModel.swift
//  QXChartView
//
//  Created by fox on 2018/8/15.
//

import UIKit

/**
 改数据的走势方向
 
 - Up:    升
 - Down:  跌
 - Equal: 相等
 */
public enum QXChartItemTrend {
    case up
    case down
    case equal
}

/**
 *  数据元素
 */
public class QXChartItem: NSObject {
    
    public var time: Int = 0
    public var openPrice: CGFloat = 0
    public var closePrice: CGFloat = 0
    public var lowPrice: CGFloat = 0
    public var highPrice: CGFloat = 0
    public var vol: CGFloat = 0
    public var value: CGFloat?
    public var extVal: [String: CGFloat] = [String: CGFloat]()        //扩展值，用来记录各种技术指标
    
    public var trend: QXChartItemTrend {
        if closePrice == openPrice {
            return .equal
            
        }else{
            //收盘价比开盘低
            if closePrice < openPrice {
                return .down
            } else {
                //收盘价比开盘高
                return .up
            }
        }
    }
    
}

public protocol QXChartModelProtocol {
    var upStyle: QXUpDownStyle {get set}
    var downStyle: QXUpDownStyle {get set}
    var titleColor: UIColor {get set}
    var lineWidth: CGFloat {get set}
    var ultimateValueStyle: QXUltimateValueStyle {get set}
    /**
     画点线
     
     - parameter startIndex:     起始索引
     - parameter endIndex:       结束索引
     - parameter plotPaddingExt: 点与点之间间断所占点宽的比例
     */
    func drawSerie(_ startIndex: Int, endIndex: Int) -> CAShapeLayer
    
    func drawGuideValue(value: String, section: QXSection, point:CGPoint, trend: QXChartItemTrend) -> CAShapeLayer
}

extension QXChartModelProtocol {
    
    public func drawGuideValue(value: String, section: QXSection, point:CGPoint, trend: QXChartItemTrend) -> CAShapeLayer {
        
        let guideValueLayer = CAShapeLayer()
        
        let fontSize = value.qx_sizeWithConstrained(section.labelFont)
        let arrowLineWidth: CGFloat = 4
        var isUp: CGFloat = -1
        var isLeft: CGFloat = -1
        var tagStartY: CGFloat = 0
        var isShowValue: Bool = true
        
        var guideValueTextColor: UIColor = .white
        
        var maxPriceStartX = point.x + arrowLineWidth * 2
        var maxPriceStartY: CGFloat = 0
        
        if maxPriceStartX + fontSize.width > section.frame.origin.x + section.frame.size.width - section.padding.right {
            isLeft = -1
            maxPriceStartX = point.x + arrowLineWidth * 2 * isLeft - fontSize.width
        } else {
            isLeft = 1
        }
        
        var fillColor: UIColor = self.upStyle.color
        
        switch trend {
        case .up:
            fillColor = self.upStyle.color
            isUp = -1
            tagStartY = point.y - (fontSize.height + arrowLineWidth)
            maxPriceStartY = point.y - (fontSize.height + arrowLineWidth / 2)
        case .down:
            fillColor = self.downStyle.color
            isUp = 1
            tagStartY = point.y
            maxPriceStartY = point.y + arrowLineWidth / 2
        default: break
            
        }
        switch self.ultimateValueStyle {
        case .arrow(let color):
            let arrowPath = UIBezierPath()
            let arrowLayer = CAShapeLayer()
            
            guideValueTextColor = color
            
            arrowPath.move(to: CGPoint(x: point
                .x, y: point.y + arrowLineWidth * isUp))
            arrowPath.addLine(to: CGPoint(x: point.x + arrowLineWidth * isLeft, y: point.y + arrowLineWidth * isUp))
            
            arrowPath.move(to: CGPoint(x: point.x, y: point.y + arrowLineWidth * isUp))
            arrowPath.addLine(to: CGPoint(x: point.x, y: point.y + arrowLineWidth * isUp * 2))
            
            arrowPath.move(to: CGPoint(x: point.x, y: point.y + arrowLineWidth * isUp))
            arrowPath.addLine(to: CGPoint(x: point.x + arrowLineWidth * isLeft, y: point.y + arrowLineWidth * isUp * 2))
            
            arrowLayer.path = arrowPath.cgPath
            arrowLayer.strokeColor = self.titleColor.cgColor
            
            guideValueLayer.addSublayer(arrowLayer)
        case .circle(let color , let show):
            let circleLayer = CAShapeLayer()
            
            guideValueTextColor = color
            isShowValue = show
            
            let circleWidth: CGFloat = 6
            let circlePoint = CGPoint(x: point.x - circleWidth / 2, y: point.y - circleWidth / 2)
            let circleSize = CGSize(width: circleWidth, height: circleWidth)
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: circlePoint, size: circleSize))
            
            circleLayer.lineWidth = self.lineWidth
            circleLayer.path = circlePath.cgPath
            circleLayer.fillColor = section.backgroundColor.cgColor
            circleLayer.strokeColor = fillColor.cgColor
            
            guideValueLayer.addSublayer(circleLayer)
        case .tag(let color):
            break
        default:
            isShowValue = false
            break
            
        }
        
        if isShowValue {
            let point = CGPoint(x: maxPriceStartX, y: maxPriceStartY)
            
            let textSize = value.qx_sizeWithConstrained(section.labelFont)
            
            let valueText = QXTextLayer()
            valueText.frame = CGRect(origin: point, size: textSize)
            valueText.string = value
            valueText.fontSize = section.labelFont.pointSize
            valueText.foregroundColor = guideValueTextColor.cgColor
            valueText.backgroundColor = UIColor.clear.cgColor
            valueText.contentsScale = UIScreen.main.scale
            
            guideValueLayer.addSublayer(valueText)
        }
        
        return guideValueLayer
    }
}

public typealias QXUpDownStyle = (color: UIColor, isSolid: Bool)

open class QXChartModel : QXChartModelProtocol {
  
    open var upStyle: QXUpDownStyle = (.red, true)
    
    open var downStyle: QXUpDownStyle = (.green, true)
    
    open var titleColor: UIColor = .white
    
    open var datas: [QXChartItem] = [QXChartItem]()
    
    /// 小数的长度
    open var decimal: Int = 2
    
    /// 是否显示最大值
    open var showMaxVal: Bool = false
    /// 是否显示最小值
    open var showMinVal: Bool = false
    
    open var title: String = ""
    
    open var useTitleColor = true
    
    open var key: String = ""
    
    open var ultimateValueStyle: QXUltimateValueStyle = .none
    /// 线段宽度
    open var lineWidth: CGFloat = 0.6
    /// 点与点之间间断所占点宽的比例
    open var plotPaddingExt: CGFloat =  0.165
    
    weak var section: QXSection!
    
    convenience init(
        upStyle: QXUpDownStyle,
        downStyle: QXUpDownStyle,
        title: String = "",
        titleColor: UIColor,
        datas:[QXChartItem] = [QXChartItem](),
        decimal:Int = 2,
        plotPaddingExt: CGFloat = 0.165
        ) {
        self.init()
        self.upStyle = upStyle
        self.downStyle = downStyle
        self.title = title
        self.titleColor = titleColor
        self.datas = datas
        self.decimal = decimal
        self.plotPaddingExt = plotPaddingExt
    }
    
    public func drawSerie(_ startIndex: Int, endIndex: Int) -> CAShapeLayer {
        return CAShapeLayer()
    }
}

extension QXChartModel {
    public subscript(index:Int) -> QXChartItem {
        var value: CGFloat?
        let item = self.datas[index]
        value = item.extVal[self.key]
        item.value = value
        return item
    }
}

open class QXLineModel: QXChartModel {
    public override func drawSerie(_ startIndex: Int, endIndex: Int) -> CAShapeLayer {
        let serieLayer = CAShapeLayer()
        
        let modelLayer = CAShapeLayer()
        
        modelLayer.strokeColor = self.upStyle.color.cgColor
        modelLayer.fillColor = UIColor.clear.cgColor
        modelLayer.lineWidth = CGFloat(self.lineWidth)
        modelLayer.lineCap = kCALineCapRound
        modelLayer.lineJoin = kCALineJoinBevel
        
        let plotWidth = self.section.frame.size.width / CGFloat(endIndex - startIndex)
        
        let linePath = UIBezierPath()
        
        // 最大值的项
        var maxValue: CGFloat = 0
        // 最大值所在的坐标
        var maxPoint: CGPoint?
        
        var minValue: CGFloat = CGFloat.greatestFiniteMagnitude
        
        var minPoint: CGPoint?
        
        var isStartDraw = false
        
        for i in stride(from: startIndex, to: endIndex, by: 1) {
            guard let value = self[i].value else {
                continue
            }
            
            //X 开始位置
            let ix = self.section.frame.origin.x + self.section.padding.left + CGFloat(i - startIndex) * plotWidth;
            // 在 y 轴上的位置
            let iys = self.section.getLocalY(value)
            
            let point = CGPoint(x: ix + plotWidth / 2, y: iys)
            
            if !isStartDraw {//第一个点
                linePath.move(to: point)
                isStartDraw = true
            } else {
                linePath.addLine(to: point)
            }
            // 记录最大值
            if value > maxValue {
                maxValue = value
                maxPoint = point
            }
            
            // 记录最小值
            if value < minValue {
                minValue = value
                minPoint = point
            }
        }
        modelLayer.path = linePath.cgPath
        
        serieLayer.addSublayer(modelLayer)
        
        // 显示最大最小值
        if self.showMaxVal && maxValue != 0 {
            let highPrice = maxValue.qx_toString(maxF:section.decimal)
            let maxLayer = self.drawGuideValue(value: highPrice, section: self.section, point: maxPoint!, trend: QXChartItemTrend.up)
            serieLayer.addSublayer(maxLayer)
        }
        
        if self.showMinVal && minValue != CGFloat.greatestFiniteMagnitude {
            let lowPrice = minValue.qx_toString(maxF: section.decimal)
            let minLayer = self.drawGuideValue(value: lowPrice, section: section, point: minPoint!, trend: .down)
            serieLayer.addSublayer(minLayer)
        }
        
        return serieLayer
    }
}


open class QXCandleModel: QXChartModel {
    var drawShadow = true
    
    open override func drawSerie(_ startIndex: Int, endIndex: Int) -> CAShapeLayer {
        // TODO:
        
        return CAShapeLayer()
    }
}


extension QXChartModel {
    class func getLine(_ color: UIColor, title: String, key: String) -> QXLineModel {
       let model = QXLineModel(upStyle: (color, true), downStyle: (color, true), titleColor: color)
        model.title = title
        model.key = key
        return model
    }
    
    
    //生成一个蜡烛样式
//    class func getCandle(upStyle: (color: UIColor, isSolid: Bool),
//                         downStyle: (color: UIColor, isSolid: Bool),
//                         titleColor: UIColor,
//                         key: String = QXSeriesKey.candle) -> QXCandleModel {
//        let model = QXCandleModel(upStyle: upStyle, downStyle: downStyle,
//                                  titleColor: titleColor)
//        model.key = key
//        return model
//    }
}




let m = QXChartModel()

