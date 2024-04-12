//
//  ViewController.swift
//  LRSwiftyTools
//
//  Created by WinTer on 12/14/2022.
//  Copyright (c) 2022 WinTer. All rights reserved.
//

import UIKit
import LRSwiftyTools

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .purple
        let h = LRHoleView(frame: self.view.bounds)
        h.config = LRHoleConfig(rect: CGRect(x: 100, y: 100, width: 100, height: 100), corners: [.allCorners], cornerRadii:CGSize(width: 50, height: 50), fillColor: .red, strokeColor: .yellow)
        self.view.addSubview(h)
        
        let lable = UILabel(frame: CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 100));
        lable.text = "Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib."
        lable.numberOfLines = 0;
        lable.lineSpace = 20;
        self.view.addSubview(lable)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

