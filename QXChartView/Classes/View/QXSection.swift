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
}
