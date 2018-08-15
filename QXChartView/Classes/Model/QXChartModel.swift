//
//  QXChartModel.swift
//  QXChartView
//
//  Created by fox on 2018/8/15.
//

import Foundation
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
public struct QXChartItem {
    
    public var time: Int = 0
    public var openPrice: Float = 0
    public var closePrice: Float = 0
    public var lowPrice: Float = 0
    public var highPrice: Float = 0
    public var vol: Float = 0
    public var value: Float?
    public var extVal: [String: Float] = [String: Float]()        //扩展值，用来记录各种技术指标
    
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

    
}

open class QXChartModel : QXChartModelProtocol {
   
    open var upStyle: (color: UIColor, isSolid: Bool) = (.red, true)
    
    open var downStyle: (color: UIColor, isSolid: Bool) = (.green, true)
    
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
}



let m = QXChartModel()

