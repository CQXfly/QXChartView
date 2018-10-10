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

@objc public protocol QXKLineChartDelegate: class {
    func numberOfPointsInKLineChart(_ chart: QXKLineChartView) -> Int
    
    func kLineChart(_ chart: QXKLineChartView, valueForPointAtIndex: Int) -> QXChartItem
    
    func kLineChart(_ chart: QXKLineChartView, labelOnYAxisForValue value: CGFloat, atIndex index: Int, section
        : QXSection) -> String
    
    func kLineChart(_ chart: QXKLineChartView, labelOnXAxisForValue index: Int) -> String
    
    @objc optional func didFinishKLineChartRefresh(chart: QXKLineChartView)
    
    @objc optional func kLineChart(_ chart: QXKLineChartView, decimalAt section: Int) -> Int
    
    @objc optional func widthForYAxisLabelInKLineChart(in chart:QXKLineChartView) -> CGFloat
    
    @objc optional func kLineChart(chart: QXKLineChartView, didSelectAt index: Int,item: QXChartItem)
    
    @objc optional func heightForXAxisInKlineChart(in chart: QXKLineChartView) -> CGFloat
    
    @objc optional func kLineChart(chart: QXKLineChartView, viewOfYAxis yAxis: UILabel, viewOfAxis: UILabel)
    
    @objc optional func initRangeInKlineChart(in chart: QXKLineChartView) -> Int
    
    @objc optional func kLineChart(chart: QXKLineChartView, viewForHeaderInSection section: Int) -> UIView?
    
    @objc optional func kLineChart(chart: QXKLineChartView, titleForHeaderInsection section: QXSection, index: Int, item: QXChartItem) -> NSAttributedString?
    
    @objc optional func kLineChart(chart: QXKLineChartView,didFlipPageSeries section: QXSection, series: QXSeries, seriesIndex: Int)
    
    @objc optional func needsMoreData(chart: QXKLineChartView)
    
}


open class QXKLineChartView:UIView {
    let kMinRange = 13
    let kMaxRange = 133
    let kPerInterval = 4 //缩放的每段间隔
    
    let kYAxisLabelWidth: CGFloat = 46
    let kXAsisHeight: CGFloat = 16
    
    @IBInspectable open var upColor : UIColor = UIColor.red
    @IBInspectable open var downColor: UIColor = UIColor.green
    
    @IBInspectable open var labelFont = UIFont.systemFont(ofSize: 10)
    @IBInspectable open var lineColor = UIColor(white: 0.2, alpha: 1)
    @IBInspectable open var textColor = UIColor(white: 0.8, alpha: 1)
    @IBInspectable open var  xAxisPerInterval: Int = 4
    
    open var yAxisLabelWidth: CGFloat = 0
    open var handlerOfAlgorithms: [QXChartAlgorithmProtocol] = [QXChartAlgorithmProtocol]()
    
    open var padding: UIEdgeInsets = UIEdgeInsets.zero
    open var showYAxisLabel = QXYAxisShowPosition.right
    
    open var isInnerYAxis: Bool = false
    
    open var selectedPosition: QXChartSelectedPosition = .onClosePrice
    
    open weak var delegate: QXKLineChartDelegate? //代理
    
    open var sections = [QXSection]()
    
    open var selectedIndex: Int = -1
    
    open var scrollToPosition: QXChartViewScrollPosition = .none
    
    var selectedPoint: CGPoint = CGPoint.zero
    
    open var enablePinch: Bool = true
    
    open var enablePan: Bool = true
    
    open var enableTap: Bool = true {
        didSet {
            self.showSelection = self.enablePan
        }
    }
    // 是否显示选中的内容
    open var showSelection: Bool = true {
        didSet {
            self.selectedXAxisLabel?.isHidden = !self.showSelection
            self.selectedYAxisLabel?.isHidden = !self.showSelection
            self.verticalLineView?.isHidden = !self.showSelection
            self.horizontalLineView?.isHidden = !self.showSelection
            self.sightView?.isHidden = !self.showSelection
        }
    }
    
    open var showXAxisOnSection: Int = -1
    
    open var showXAxisLabel: Bool = true
    
    open var isShowAll: Bool = false
    
    open var borderWidth: (top: CGFloat, left:CGFloat, bottom: CGFloat, right: CGFloat) = (0.25, 0.25, 0.25, 0.25)
    
    var lineWidth: CGFloat = 0.5
    
    var plotCount: Int = 0
    
    var rangeFrom: Int = 0  //可见区域的开始索引位
    
    var rangTo: Int = 0     //可见区域的结束索引位
    
    open var range: Int = 77 //显示在可见区域的个数
    
    var borderColor: UIColor = UIColor.gray
    open var labelSize = CGSize(width: 40, height: 16)
    
    var datas: [QXChartItem] = [QXChartItem]()
    
    open var selectedBGColor = UIColor(white: 0.4, alpha: 1)
    
    open var selectedTextColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    
    var verticalLineView: UIView?
    
    var horizontalLineView: UIView?
    
    var selectedXAxisLabel: UILabel?
    var selectedYAxisLabel: UILabel?
    var sightView:UIView?
    
    //动力学引擎
    lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    
    var dynamicItem: QXDynamicItem = QXDynamicItem()
    
    weak var decelerationBehavior: UIDynamicItemBehavior?
    
    weak var springBehavior: UIAttachmentBehavior?
    
    var decelerationStartX: CGFloat = 0
    
    var drawLayer: QXShapeLayer = QXShapeLayer()
    
    var chartModelLayer: QXShapeLayer = QXShapeLayer()
    
    var chartInfoLayer: QXShapeLayer = QXShapeLayer()
    
    open var style: QXKLineChartStyle! {
        didSet{
            self.sections = self.style.sections
            self.backgroundColor = self.style.backgroundColor
            self.padding = self.style.padding
            self.handlerOfAlgorithms = self.style.algorithms
            self.lineColor = self.style.lineColor
            self.textColor = self.style.textColor
            self.labelFont = self.style.labelFont
            self.showYAxisLabel = self.style.showYAxisLabel
            self.selectedBGColor = self.style.selectedBGColor
            self.selectedTextColor = self.style.selectedTextColor
            self.isInnerYAxis = self.style.isInnerYAxis
            self.enableTap = self.style.enableTap
            self.enablePinch = self.style.enablePinch
            self.enablePan = self.style.enablePan
            self.showSelection = self.style.showSelection
            self.showXAxisOnSection = self.style.showXAxisOnSection
            self.isShowAll = self.style.isShowAll
            self.showXAxisLabel = self.style.showXAxisLabel
            self.borderWidth = self.style.borderWidth
        }
    }
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }
    
    fileprivate func initUI() {
        self.isMultipleTouchEnabled = true
        
        self.verticalLineView = UIView(frame: CGRect(x: 0, y: 0, width: lineWidth, height: 0))
        self.verticalLineView?.backgroundColor = self.selectedBGColor
        self.verticalLineView?.isHidden = true
        self.addSubview(self.verticalLineView!)
        
        self.horizontalLineView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: lineWidth))
        self.horizontalLineView?.backgroundColor = self.selectedBGColor
        self.horizontalLineView?.isHidden = true
        self.addSubview(self.horizontalLineView!)
        
        //用户点击图表显示当前y轴的实际值
        self.selectedYAxisLabel = UILabel(frame: CGRect.zero)
        self.selectedYAxisLabel?.backgroundColor = self.selectedBGColor
        self.selectedYAxisLabel?.isHidden = true
        self.selectedYAxisLabel?.font = self.labelFont
        self.selectedYAxisLabel?.minimumScaleFactor = 0.5
        self.selectedYAxisLabel?.lineBreakMode = .byClipping
        self.selectedYAxisLabel?.adjustsFontSizeToFitWidth = true
        self.selectedYAxisLabel?.textColor = self.selectedTextColor
        self.selectedYAxisLabel?.textAlignment = NSTextAlignment.center
        self.addSubview(self.selectedYAxisLabel!)
        
        //用户点击图表显示当前x轴的实际值
        self.selectedXAxisLabel = UILabel(frame: CGRect.zero)
        self.selectedXAxisLabel?.backgroundColor = self.selectedBGColor
        self.selectedXAxisLabel?.isHidden = true
        self.selectedXAxisLabel?.font = self.labelFont
        self.selectedXAxisLabel?.textColor = self.selectedTextColor
        self.selectedXAxisLabel?.textAlignment = NSTextAlignment.center
        self.addSubview(self.selectedXAxisLabel!)
        
        
        self.sightView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
        self.sightView?.backgroundColor = self.selectedBGColor
        self.sightView?.isHidden = true
        self.sightView?.layer.cornerRadius = 3
        self.addSubview(self.sightView!)
        
        //绘画图层
        self.layer.addSublayer(self.drawLayer)
        
        //添加手势操作
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(doPanAction(_:)))
        pan.delegate = self
        
        self.addGestureRecognizer(pan)
        
        //点击手势操作
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(doTapAction(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        //双指缩放操作
        let pinch = UIPinchGestureRecognizer(
            target: self,
            action: #selector(doPinchAction(_:)))
        pinch.delegate = self
        self.addGestureRecognizer(pinch)
        
        //长按手势操作
        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(doLongPressAction(_:)))
        //长按时间为1秒
        longPress.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPress)
        
        //加载一个初始化的Range值
        if let userRange = self.delegate?.initRangeInKlineChart?(in: self) {
            self.range = userRange
        }
        
        //初始数据
        self.resetData()
        
    }
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.drawLayerView()
    }
    
    fileprivate func resetData() {
        self.datas.removeAll()
        
        self.plotCount = self.delegate?.numberOfPointsInKLineChart(self) ?? 0
        
        guard self.plotCount > 0  else {
            return
        }
        
        for i in 0 ... (self.plotCount - 1) {
            let item = self.delegate?.kLineChart(self, valueForPointAtIndex: i)
            self.datas.append(item!)
        }
        
        for algorithm in self.handlerOfAlgorithms {
            self.datas = algorithm.handleAlgorithm(self.datas)
        }
    }
    
    func getSectionByTouchPoint(_ point: CGPoint) -> (Int, QXSection?) {
        for (i, section) in self.sections.enumerated() {
            if section.frame.contains(point) {
                return (i, section)
            }
        }
        
        return (-1, nil)
    }
    
    func getSectionWhichShowAxis() -> QXSection {
        let visiableSection = sections.filter{!$0.hidden}
        var showSection: QXSection?
        for (i, section) in visiableSection.enumerated() {
            if section.index == self.showXAxisOnSection {
                showSection = section
            }
            
            if i == visiableSection.count - 1 && showSection == nil{
                showSection = section
            }
        }
        return showSection!
    }
    
    
    func setSelectedIndexByPoint(_ point: CGPoint) {
        guard self.enableTap else {
            return
        }
        
        guard !point.equalTo(CGPoint.zero) else {
            return
        }
        
        let (_, s) = getSectionByTouchPoint(point)
        
        guard let section = s else {
            return
        }
        
        let visiablSections = sections.filter{!$0.hidden}
        
        guard let lastSection = visiablSections.last else {
            return
        }
        
        let showXAxisSection = self.getSectionWhichShowAxis()
        
        //重置文字颜色和字体
        self.selectedYAxisLabel?.font = self.labelFont
        self.selectedYAxisLabel?.backgroundColor = self.selectedBGColor
        self.selectedYAxisLabel?.textColor = self.selectedTextColor
        self.selectedXAxisLabel?.font = self.labelFont
        self.selectedXAxisLabel?.backgroundColor = self.selectedBGColor
        self.selectedXAxisLabel?.textColor = self.selectedTextColor
        
        let yAxis = section.yAxis
        let fromat = "%.".appendingFormat("%df", yAxis.decimal)
        
        selectedPoint = point
        
        let plotWidth = (section.frame.size.width - section.padding.left - section.padding.right) / CGFloat(self.rangTo - self.rangeFrom)
        
        var yVal: CGFloat = 0
        
        for i in self.rangeFrom ..< self.rangTo {
            let ixs = plotWidth * CGFloat(i - self.rangeFrom) + section.padding.left + padding.left
            
            let ixe = plotWidth * CGFloat(i - self.rangeFrom + 1) + section.padding.left + padding.left
            
            if ixs <= point.x && point.x < ixe {
                selectedIndex = i
                let item = datas[i]
                // 画十字线
                var hx = section.frame.origin.x + section.padding.left
                hx = hx + plotWidth * CGFloat(i - rangeFrom) + plotWidth / 2
                let hy = padding.top
                let hheight = lastSection.frame.maxY
                
                horizontalLineView?.frame = CGRect(x:hx, y: hy, width: lineWidth, height: hheight)
                
                let vx = section.frame.origin.x + section.padding.left
                var vy: CGFloat = 0
                
                switch selectedPosition {
                case .free:
                    vy = point.y
                    yVal = section.getRawValue(point.y)//获取y轴坐标的实际值
                case .onClosePrice:
                    if let series = section.getSeries(key: QXSeriesKey.candle),!series.hidden {
                        yVal = item.closePrice
                    } else if let series = section.getSeries(key: QXSeriesKey.timeline), !series.hidden {
                        yVal = item.closePrice
                    } else  if let series = section.getSeries(key: QXSeriesKey.volume), !series.hidden {
                        yVal = item.vol
                    }
                    
                    vy = section.getLocalY(yVal)
                }
                
                let hwidth = section.frame.size.width - section.padding.left - section.padding.right
                //显示辅助线
                verticalLineView?.frame = CGRect(x: vx, y: vy - self.lineWidth / 2, width: hwidth, height: lineWidth)
                
                var yAxisStartX: CGFloat = 0
                
                switch self.showYAxisLabel {
                case .left:
                    yAxisStartX = section.frame.origin.x
                case .right:
                    yAxisStartX = section.frame.maxX - self.yAxisLabelWidth
                case .none:
                    self.selectedYAxisLabel?.isHighlighted = true
                }
                
                self.selectedYAxisLabel?.text = String(format: fromat, yVal)
                
                self.selectedYAxisLabel?.frame = CGRect(x: yAxisStartX, y: vy - self.labelSize.height / 2, width: self.yAxisLabelWidth, height: self.labelSize.height )
                
                let time = Date.qx_getTimeByStamp(item.time, format: "yyyy-MM-dd HH:mm")
                let size = time.qx_sizeWithConstrained(labelFont)
                selectedXAxisLabel?.text = time
                
                //判断x是否超过左右边界
                let labelWidth = size.width + 6
                var x = hx - (labelWidth) / 2
                
                if x < section.frame.origin.x {
                    x = section.frame.origin.x
                } else if x + labelWidth > section.frame.size.width - labelWidth {
                    x = section.frame.size.width +  section.frame.origin.x - labelWidth
                }
                
                self.selectedXAxisLabel?.frame = CGRect(x: x, y: showXAxisSection.frame.maxY, width: size.width + 6, height: labelSize.height)
                
                self.sightView?.center = CGPoint(x: hx, y: vy)
                
                self.delegate?.kLineChart?(chart: self, viewOfYAxis: self.selectedYAxisLabel!, viewOfAxis: self.selectedXAxisLabel!)
                
                self.showSelection = true
                
                bringSubview(toFront: verticalLineView!)
                bringSubview(toFront: horizontalLineView!)
                bringSubview(toFront: selectedXAxisLabel!)
                bringSubview(toFront: selectedYAxisLabel!)
                bringSubview(toFront: sightView!)
                
                self.setSelectedIndexByIndex(i)
                break
            }
        }
        
        
    }
    
    
    /// 设置选中的数据点
    ///
    /// - Parameter index: 选中位置
    func setSelectedIndexByIndex(_ index: Int) {
        guard index >= self.rangeFrom && index < self.rangTo else {
            return
        }
        
        selectedIndex = index
        let item = self.datas[selectedIndex]
        
        for (_, section) in self.sections.enumerated() {
            if section.hidden {
                continue
            }
            
            if let titleString = self.delegate?.kLineChart?(chart: self, titleForHeaderInsection: section, index: index, item: item) {
                section.drawTitleForHeader(title: titleString)
            } else {
                section.drawTitle(index)
            }
        }
        
        self.delegate?.kLineChart?(chart: self, didSelectAt: index, item: item)
    }
   
}

extension QXKLineChartView {
    
    func removeLayerView() {
        for section in self.sections {
            section.removeLayerView()
            for series in section.series {
                series.removeLayerView()
            }
        }
        _ = drawLayer.sublayers?.map{$0.removeFromSuperlayer()}
        
        drawLayer.sublayers?.removeAll()
    }
    
    
    func drawLayerView() {
        self.removeLayerView()
        
        if self.initChart() {
            var xAxisToDraw = [(CGRect, String)]()
            
            self.buildSections {(section, index) in
                let decimal = self.delegate?.kLineChart?(self, decimalAt: index) ?? 2
                section.decimal = decimal
                
                // TODO: 初始化Y轴的数据
                self.initYAxis(section)
                
                // TODO: 绘制每个section区域
                self.drawSection(section)
                
                
            }
        }
    }
    
    
    /// 初始化图表结构
    fileprivate func initChart() -> Bool {
        plotCount = self.delegate?.numberOfPointsInKLineChart(self) ?? 0
        
        if self.plotCount != self.datas.count {
            self.resetData()
        }
        
        if plotCount > 0 {
            if isShowAll {
                range = plotCount
                rangeFrom = 0
                rangTo = plotCount
            }
            
            if scrollToPosition == .none {
                if rangTo == 0 || plotCount < rangTo {
                    scrollToPosition = .end
                }
            }
            
            if scrollToPosition == .top {
                rangeFrom = 0
                if rangeFrom + range < plotCount {
                    rangTo = rangeFrom + range
                } else {
                    rangTo = plotCount
                }
                selectedIndex = -1
            } else if scrollToPosition == .end {
                rangTo = plotCount
                if rangTo - range > 0 {
                    rangeFrom = rangTo - range
                } else {
                    rangeFrom = 0
                }
                selectedIndex = -1
            }
        }
        
        scrollToPosition = .none
        
        if selectedIndex == -1 {
            selectedIndex = rangTo - 1
        }
        
        let backgroundLayer = QXShapeLayer()
        let backgroundPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height), cornerRadius: 0)
        backgroundLayer.path = backgroundPath.cgPath
        backgroundLayer.fillColor = backgroundColor?.cgColor
        self.drawLayer.addSublayer(backgroundLayer)
        
        return datas.count > 0
    }
    
    
    fileprivate func initYAxis(_ section: QXSection) {
        if section.series.count > 0 {
            section.buildYAxis(startIndex: rangeFrom, endIndex: rangTo, datas: datas)
        }
    }
    
    fileprivate func drawSection(_ section: QXSection) {
        
        // 背景
        let sectionPath = UIBezierPath(rect: section.frame)
        let sectionLayer = QXShapeLayer()
        sectionLayer.fillColor = section.backgroundColor.cgColor
        sectionLayer.path = sectionPath.cgPath
        self.drawLayer.addSublayer(sectionLayer)
        
        let borderPath = UIBezierPath()
        
        // 底部边线
        if borderWidth.bottom > 0 {
            borderPath.append(UIBezierPath(rect: CGRect(x: section.frame.origin.x + section.padding.left, y: section.frame.size.height + section.frame.origin.y, width: section.frame.size.width - section.padding.left, height: borderWidth.bottom)))
        }
        
        
        if borderWidth.top > 0 {
            borderPath.append(UIBezierPath(rect: CGRect(x: section.frame.origin.x + section.padding.left, y: section.frame.origin.y, width: section.frame.size.width - section.padding.left, height: borderWidth.top)))
        }
        
        if borderWidth.left > 0 {
            borderPath.append(UIBezierPath(rect: CGRect(x: section.frame.origin.x + section.padding.left, y: section.frame.origin.y, width: borderWidth.left, height: section.frame.size.height)))
        }
        
        if self.borderWidth.right > 0 {
            
            borderPath.append(UIBezierPath(rect: CGRect(x: section.frame.origin.x + section.frame.size.width - section.padding.right, y: section.frame.origin.y, width: self.borderWidth.left, height: section.frame.size.height)))
            
        }
        
        let borderLayer = QXShapeLayer()
        borderLayer.lineWidth = self.lineWidth
        borderLayer.path = borderPath.cgPath  // 从贝塞尔曲线获取到形状
        borderLayer.fillColor = self.lineColor.cgColor // 闭环填充的颜色
        self.drawLayer.addSublayer(borderLayer)
    }
    
    fileprivate func drawYAxis(_ section: QXSection) -> [(CGRect, String)] {
        var yAxisToDraw = [(CGRect, String)]()
        var valueToDraw = Set<CGFloat>()
        
        var startX: CGFloat = 0, startY: CGFloat = 0, extrude: CGFloat = 0
        var showYAxisLabel: Bool = true;
        var showYAxisReference: Bool = true
        
        switch self.showYAxisLabel {
        case .left:
            startX = section.frame.origin.x - 3 * (self.isInnerYAxis ? -1 : 1)
            extrude = section.frame.origin.x + section.padding.left + 2
        case .right:
            startX = section.frame.maxX - self.yAxisLabelWidth + 3 * (self.isInnerYAxis ? -1 : 1)
            extrude = section.frame.origin.x + section.padding.left + section.frame.size.width - section.padding.right

        case .none:
            showYAxisLabel = false
        }
        
        let yaxis = section.yAxis
        
        let step = (yaxis.max - yaxis.min) / CGFloat(yaxis.tickInterval)
        
        var i = 0
        var yval = yaxis.baseValue - CGFloat(i) * step
        
        while yval <= yaxis.max && i <= yaxis.tickInterval {
            valueToDraw.insert(yval)
            
            i = i + 1
            yval = yaxis.baseValue - CGFloat(i) * step
        }
        
        for (i , yval) in valueToDraw.enumerated() {
            let iy = section.getLocalY(yval)
            
            if self.isInnerYAxis {
                startY = iy - 14
            } else {
                startY = iy - 7
            }
            
            let referencePath = UIBezierPath()
            let referenceLayer = QXShapeLayer()
            
            referenceLayer.lineWidth = self.lineWidth
            
            switch section.yAxis.assistLineStyle {
            case .dash(color: let dashColor, pattern: let pattern):
                referenceLayer.strokeColor = dashColor.cgColor
                referenceLayer.lineDashPattern = pattern
                showYAxisReference = true
            case .solid(color: let solidColor):
                referenceLayer.strokeColor = solidColor.cgColor
                showYAxisReference = true
            default:
                showYAxisReference = false
                startY = iy - 7
            }
            
            if showYAxisReference {
                if !self.isInnerYAxis {
                    referencePath.move(to: CGPoint(x: extrude, y: iy))
                    referencePath.addLine(to: CGPoint(x: extrude + 2, y: iy))
                }
                
                referencePath.move(to: CGPoint(x: section.frame.origin.x + section.padding.left, y: iy))
                referencePath.addLine(to: CGPoint(x: section.frame.origin.x + section.frame.size.width - section.padding.right, y: iy))
                referenceLayer.path = referencePath.cgPath
                drawLayer.addSublayer(referenceLayer)
                
            }
            
            if showYAxisLabel {
                let strValue = self.delegate?.kLineChart(self, labelOnYAxisForValue: yval, atIndex: i, section: section) ?? ""
                let yLabelRect = CGRect(x: startX, y: startY, width: yAxisLabelWidth, height: 12)
                
                yAxisToDraw.append((yLabelRect, strValue))
            }
        }
        
        return yAxisToDraw
    }
    
    ///初始化各个分区
    ///
    /// - Parameter complete: 初始化后 执行每个分区的绘制
    fileprivate func buildSections(_ complete:(_ section: QXSection, _ index: Int)->Void) {
        var height = frame.size.height - padding.top - padding.bottom
        
        let width = frame.size.width - padding.left - padding.right
        
        let xAxisHeight = self.delegate?.heightForXAxisInKlineChart?(in: self) ?? self.kXAsisHeight
        
        height = height - xAxisHeight
        
        var total = 0
        
        for (index, section) in sections.enumerated() {
            section.index = index
            if !section.hidden {
                if section.ratios > 0 {
                    total = total + section.ratios
                }
            }
        }
        
        var offsetY: CGFloat = padding.top
        
        for (index ,section) in sections.enumerated() {
            var heightOfSection: CGFloat = 0
            let widthOfSection = width
            if section.hidden {
                continue
            }
            if section.fixHeight > 0 {
                heightOfSection = section.fixHeight
                height = height - heightOfSection
            } else {
                heightOfSection = height * CGFloat(section.ratios)/CGFloat(total)
            }
            
            yAxisLabelWidth = self.delegate?.widthForYAxisLabelInKLineChart?(in: self) ?? kYAxisLabelWidth
            
            switch showYAxisLabel {
            case .left:
                section.padding.left = isInnerYAxis ? section.padding.left : yAxisLabelWidth
            case .right:
                section.padding.left = 0
                section.padding.right = isInnerYAxis ? section.padding.right : yAxisLabelWidth
            case .none:
                section.padding.left = 0
                section.padding.right = 0
            }
            
            section.frame = CGRect(x: 0 + padding.left, y: offsetY, width: widthOfSection, height: heightOfSection)
            
            offsetY = offsetY + section.frame.height
            
            if showXAxisOnSection == index {
                offsetY = offsetY + xAxisHeight
            }
            
            complete(section, index)
        }
    }
}

extension QXKLineChartView: UIGestureRecognizerDelegate {
    
    @objc func doPanAction(_ sender: UIPanGestureRecognizer) {
        
    }
    
    @objc func doTapAction(_ sender: UITapGestureRecognizer) {
        
    }
    
    @objc func doPinchAction(_ sender: UIPinchGestureRecognizer) {
        
    }
    
    @objc func doLongPressAction(_ sender: UILongPressGestureRecognizer) {
        
    }
}
