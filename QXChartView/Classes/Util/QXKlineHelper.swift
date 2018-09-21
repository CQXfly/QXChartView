//
//  QXKlineHelper.swift
//  FBSnapshotTestCase
//
//  Created by fox on 2018/8/16.
//

import Foundation
import UIKit

public extension String {
    
    func qx_sizeWithConstrained(_ font: UIFont,
                                constraintRect: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))-> CGSize {
        let boundingBox = (self as NSString).boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.size
    }
    
    var qx_length: Int {
        return self.count
    }
}

public extension UIColor {
    class func qx_hex(_ hex: UInt, alpha: Float = 1.0) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xFF000) >> 16) / 255.0, green: CGFloat((hex & 0xFF000) >> 8) / 255.0, blue: CGFloat(hex & 0xFF000) / 255.0, alpha: CGFloat(alpha))
    }
}

public extension Date { 
    static func qx_getTimeByStamp(_ timestamp: Int, format: String) -> String {
        var time = ""
        if (timestamp == 0) {
            return ""
        }
        let conformTimesp = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        time = formatter.string(from: conformTimesp)
        return time
    }
}

public extension CGFloat {
    func qx_toString(_ minF: Int = 2, maxF: Int = 6, minI: Int = 1) -> String {
        let valueDecimalNumber = NSDecimalNumber(value: Double(self) as Double)
        let twoDecialPlacesFormatter = NumberFormatter()
        twoDecialPlacesFormatter.maximumFractionDigits = maxF
        twoDecialPlacesFormatter.minimumFractionDigits = minF
        twoDecialPlacesFormatter.minimumIntegerDigits = minI
        return twoDecialPlacesFormatter.string(from: valueDecimalNumber)!
    }
}

public extension Array where Element : Equatable {
    
    subscript (safe index:Int) -> Element? {
        return (0 ..< count).contains(index) ? self[index] : nil
    }
    
    mutating func qx_removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func qx_removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.qx_removeObject(object)
        }
    }
}
