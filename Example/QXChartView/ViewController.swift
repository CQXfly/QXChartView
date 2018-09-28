//
//  ViewController.swift
//  QXChartView
//
//  Created by 905799827@qq.com on 08/14/2018.
//  Copyright (c) 2018 905799827@qq.com. All rights reserved.
//

import UIKit
protocol P {
    
}

extension Int: P {
    
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        typealias QZBlock<T> = (T,Error?)->()
        
        
        let z : (P,Error?)->() = { a, e in
            
            
            print(a)
        }
        
        let b = z
        
        
        
        var c: [QZBlock<P>] = []
        
        let e = b
        
        c.append(e)
        
        print(e)
        
        print(b)
//        Value of optional type 'QZBlock<Int>??' (aka 'Optional<Optional<(Int, Optional<Error>) -> ()>>') must be unwrapped to a value of type 'QZBlock<Int>?' (aka 'Optional<(Int, Optional<Error>) -> ()>')
        
        
        c.first!(1,nil)


        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

