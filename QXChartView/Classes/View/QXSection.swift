//
//  QXSection.swift
//  QXChartView
//
//  Created by fox on 2018/8/15.
//

import Foundation
import UIKit

public enum QXSectionValueType {
    case master
    case assistant
}

open class QXSection: NSObject {
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
    func removeLayerView() {
        _ = self.sectionLayer.sublayers?.map{$0.removeFromSuperlayer()}
        sectionLayer.sublayers?.removeAll()
        _ = self.titleLayer.sublayers?.map{ $0.removeFromSuperlayer()}
        titleLayer.sublayers?.removeAll()
    }
    
    
    /// 建立Y轴左边对象
    ///
    /// - Parameters:
    ///   - model: 模型
    ///   - startIndex: 开始位
    ///   - endIndex: 结束位
    func buildYAxisPerModel(_ model: QXChartModel, startIndex: Int, endIndex: Int) {
        let datas = model.datas
        guard datas.count > 0 else {
            return
        }
        
        if !yAxis.isUsed {
            yAxis.decimal = decimal
            yAxis.max = 0
            yAxis.min = CGFloat.greatestFiniteMagnitude
            yAxis.isUsed = true
        }
        
        for i in stride(from: startIndex, to: endIndex, by: 1) {
            let item = datas[i]
            
            switch model {
            case is QXCandleModel:
                let high = item.highPrice
                let low = item.lowPrice
                if high > yAxis.max {
                    yAxis.max = high
                }
                if low < yAxis.min {
                    yAxis.min = low
                }
                
            default:
                break
            }
        }
    }
    
    func drawTitleForHeader(title: NSAttributedString) {
        guard showTitle else {
            return
        }
        
        _ = titleLayer.sublayers?.map{$0.removeFromSuperlayer()}
        titleLayer.sublayers?.removeAll()
        
        var yPos: CGFloat = 0
        var containterWidth: CGFloat = 0
        let textSize = title.string.qx_sizeWithConstrained(labelFont, constraintRect: CGSize(width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        if titleShowOutSide {
            yPos = frame.origin.y - textSize.height - 4
            containterWidth = frame.width
        } else {
            yPos = frame.origin.y + 2
            containterWidth = frame.width - padding.left - padding.right
        }
        
        let startX = frame.origin.x + padding.left + 2
        
        let point = CGPoint(x: startX, y: yPos)
        
        let titleText = QXTextLayer()
        titleText.frame = CGRect(origin: point, size: CGSize(width: containterWidth, height: textSize.height + 20))
        titleText.string = title
        titleText.fontSize = labelFont.pointSize
        titleText.backgroundColor = UIColor.clear.cgColor
        titleText.contentsScale = UIScreen.main.scale
        titleText.isWrapped = true
        
        titleLayer.addSublayer(titleText)
    }
    
    func nextPage() {
        if(self.selectedIndex < self.series.count - 1) {
            self.selectedIndex += 1
        } else {
            self.selectedIndex = 0
        }
    }
}

extension QXSection {
    
    public func buildYAxis(startIndex: Int, endIndex: Int, datas: [QXChartItem] ) {
        yAxis.isUsed = false
        var baseValueSticky = false
        var symmetrical = false
        
        if self.paging {
            let serie = self.series[self.selectedIndex]
            baseValueSticky = serie.baseValueSticky
            symmetrical = serie.symmetrical
            for serieModel in serie.chartModels {
                serieModel.datas = datas
                self.buildYAxisPerModel(serieModel, startIndex: startIndex, endIndex: endIndex)
            }
        } else {
            for serie in series {
                if serie.hidden {
                    continue
                }
                baseValueSticky = serie.baseValueSticky
                symmetrical = serie.symmetrical
                
                for serieModel in serie.chartModels {
                    serieModel.datas = datas
                    self.buildYAxisPerModel(serieModel, startIndex: startIndex, endIndex: endIndex)
                }
            }
        }
        
        if !baseValueSticky { //不使用固定基值
            if yAxis.max >= 0 && yAxis.min >= 0 {
                yAxis.baseValue = yAxis.min
            } else if yAxis.max < 0 && yAxis.min < 0 {
                yAxis.baseValue = yAxis.max
            } else {
                yAxis.baseValue = 0
            }
        } else {
            if yAxis.baseValue < yAxis.min {
                yAxis.min = yAxis.baseValue
            }
            
            if yAxis.baseValue > yAxis.max {
                yAxis.max = yAxis.baseValue
            }
        }
        
        if symmetrical {
            if self.yAxis.baseValue > self.yAxis.max {
                self.yAxis.max = self.yAxis.baseValue + (self.yAxis.baseValue - self.yAxis.min)
            } else if self.yAxis.baseValue < self.yAxis.min {
                self.yAxis.min =  self.yAxis.baseValue - (self.yAxis.max - self.yAxis.baseValue)
            } else {
                if (self.yAxis.max - self.yAxis.baseValue) > (self.yAxis.baseValue - self.yAxis.min) {
                    self.yAxis.min = self.yAxis.baseValue - (self.yAxis.max - self.yAxis.baseValue)
                } else {
                    self.yAxis.max = self.yAxis.baseValue + (self.yAxis.baseValue - self.yAxis.min)
                }
            }
        }
    }
    
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
    
    public func getRawValue(_ y: CGFloat) -> CGFloat {
        let max = yAxis.max
        let min = yAxis.min
        
        let yMax = getLocalY(min)
        
        let yMin = getLocalY(max)
        
        if (max == min) {
            return 0
        }
        
        let value = (y - yMax) / (yMin - yMax) * (max - min) + min
        
        return value
    }
    
    public func getSeries(key: String) -> QXSeries? {
        var serie: QXSeries?
        for s in self.series {
            if s.key == key {
                serie = s
                break
            }
        }
        return serie
    }
    
    public func drawTitle(_ chartSelectedIndex: Int) {
        guard showTitle else {
            return
        }
        
        if chartSelectedIndex == -1 {
            return
        }
        
        if self.paging {
            let series = self.series[self.selectedIndex]
            if let attributes = self.getTitleAttributesByIndex(chartSelectedIndex, series: series){
                setHeader(titles: attributes)
            }
        } else {
            var titleAttr = [(title: String, color: UIColor)]()
            for series in self.series {
                if let attributes = getTitleAttributesByIndex(chartSelectedIndex, series: series) {
                    titleAttr.append(contentsOf: attributes)
                }
            }
            setHeader(titles: titleAttr)
        }
    }
    
    public func setHeader(titles: [(title: String, color: UIColor)]) {
        var start = 0
        let titleString = NSMutableAttributedString()
        for (title, color) in titles {
            titleString.append(NSAttributedString(string: title))
            
            let range = NSMakeRange(start, title.qx_length)
            
            let colorAttribute = [NSAttributedStringKey.foregroundColor: color]
            titleString.addAttributes(colorAttribute, range: range)
            start += title.qx_length
        }
        
        drawTitleForHeader(title: titleString)
    }
    
    /// 添加用户自定义的View层到主页面
    ///
    /// - Parameter view: 用户自定义view
    public func addCustomView(_ view: UIView, inView mainView: UIView) {
        
        if self.titleView !== view {
            
            //移除以前的view
            self.titleView?.removeFromSuperview()
            self.titleView = nil
            
            var yPos: CGFloat = 0
            var containerWidth: CGFloat = 0
            if titleShowOutSide {
                yPos = self.frame.origin.y - self.padding.top
                containerWidth = self.frame.width
            } else {
                yPos = self.frame.origin.y
                containerWidth = self.frame.width - self.padding.left - self.padding.right
            }
            
            let startX = self.frame.origin.x + self.padding.left
            containerWidth = self.frame.width - self.padding.left - self.padding.right
            
            var frame = view.frame
            frame.origin.x = startX
            frame.origin.y = yPos
            frame.size.width = containerWidth
            view.frame = frame
            
            self.titleView = view
            mainView.addSubview(view)
            
        }
        
        mainView.bringSubview(toFront: self.titleView!)
        
    }
    
    public func getTitleAttributesByIndex(_ chartSelectedIndex: Int, series: QXSeries) -> [(title: String, color: UIColor)]? {
        if series.hidden {
            return nil
        }
        
        guard series.showTitle else {
            return nil
        }
        
        if chartSelectedIndex == -1 {
            return nil
        }
        
        var titleAttr = [(title: String, color: UIColor)]()
        
        if !series.title.isEmpty {
            let seriesTitle = series.title + "  "
            
            titleAttr.append((title: seriesTitle,color: self.titleColor))
        }
        
        for model in series.chartModels {
            var title = ""
            var textColor: UIColor
            let item = model[chartSelectedIndex]
            switch model { //TODO:
            case is QXCandleModel:
                if model.key != QXSeriesKey.candle {
                    continue
                }
                //振幅
                var amplitude: CGFloat = 0
                if item.openPrice > 0 {
                    amplitude = (item.closePrice - item.openPrice) / item.openPrice * 100
                }
                
                title += NSLocalizedString("O", comment: "") + ": " + item.openPrice.qx_toString(maxF: decimal) + " "
                title += NSLocalizedString("H", comment: "") + ": " +
                    item.highPrice.qx_toString(maxF: self.decimal) + "  "   //最高
                title += NSLocalizedString("L", comment: "") + ": " +
                    item.lowPrice.qx_toString(maxF: self.decimal) + "  "    //最低
                title += NSLocalizedString("C", comment: "") + ": " +
                    item.closePrice.qx_toString(maxF: self.decimal) + "  "  //收市
                title += NSLocalizedString("R", comment: "") + ": " +
                    amplitude.qx_toString(maxF: self.decimal) + "%   "        //振幅
            default:
                if item.value != nil {
                    title += model.title + ": " + item.value!.qx_toString(maxF: self.decimal) + "  "
                }  else {
                    title += model.title + ": --  "
                }
            }
            
            if model.useTitleColor {
                textColor = model.titleColor
            } else {
                switch item.trend {
                case .up , .equal:
                    textColor = model.upStyle.color
                case .down:
                    textColor = model.downStyle.color
                }
            }
            
            titleAttr.append((title:title, color: textColor))
        }
        return titleAttr
    }
    
    public func removeSeries(key: String) {
        for (index, s) in series.enumerated() {
            if s.key == key {
                self.series.remove(at: index)
                break
            }
        }
    }
}
