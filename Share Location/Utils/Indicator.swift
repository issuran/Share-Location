//
//  Indicator.swift
//  Share Location
//
//  Created by Tiago Oliveira on 01/04/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import UIKit

class Indicator: UIActivityIndicatorView {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    required init(coder aDecoder: NSCoder){
        fatalError("use init(")
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        self.style = UIActivityIndicatorView.Style.gray
    }
    
    func loadingView(_ isloading: Bool) {
        if isloading {
            self.startAnimating()
        } else {
            self.stopAnimating()
            self.hidesWhenStopped = true
            
        }
    }
}
