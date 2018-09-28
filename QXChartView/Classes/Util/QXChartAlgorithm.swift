//
//  File.swift
//  QXChartView
//
//  Created by fox on 2018/9/21.
//

import Foundation
import UIKit

public protocol QXChartAlgorithmProtocol {
    func handleAlgorithm(_ datas: [QXChartItem]) -> [QXChartItem]
}

public enum QXChartAlgorithm: QXChartAlgorithmProtocol {
    public func handleAlgorithm(_ datas: [QXChartItem]) -> [QXChartItem] {
        switch self {
        case .none:
            return self.handleTimeline(datas: datas)
        case .timeline:
            return self.handleTimeline(datas: datas)
        }
    }
    
    case none
    case timeline //分时
    
    
    public func key(_ name: String = "") -> String {
        
        switch self {
        case .none:
            return ""
        case .timeline:
            return "\(QXSeriesKey.timeline)_ \(name)"
        }
    }
}



// MARK: - 分时
extension QXChartAlgorithm {
    fileprivate func handleTimeline(datas: [QXChartItem]) -> [QXChartItem] {
        for (_ ,var data) in datas.enumerated() {
            data.extVal["\(self.key(QXSeriesKey.timeline))"] = data.closePrice
            data.extVal["\(self.key(QXSeriesKey.volume))"] = data.vol
        }
        return datas
    }
}
