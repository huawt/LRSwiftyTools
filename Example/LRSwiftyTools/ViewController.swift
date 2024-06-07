//
//  ViewController.swift
//  LRSwiftyTools
//
//  Created by WinTer on 12/14/2022.
//  Copyright (c) 2022 WinTer. All rights reserved.
//

import UIKit
import LRSwiftyTools

class ViewController: UIViewController, UITextViewDelegate {

    @LrSaved(key: "ViewController", defaultValue: true)
    var displayed: Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .purple
        let h = LRHoleView(frame: self.view.bounds)
        h.config = LRHoleConfig(rect: CGRect(x: 100, y: 100, width: 100, height: 100), corners: [.allCorners], cornerRadii:CGSize(width: 50, height: 50), fillColor: .red, strokeColor: .yellow)
        self.view.addSubview(h)
        
        let lable = UILabel(frame: CGRect(x: 0, y: 300, width: self.view.bounds.width, height: 100));
        lable.text = "Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib.Do any additional setup after loading the view, typically from a nib."
        lable.numberOfLines = 0;
        lable.lineSpace = 10;
        self.view.addSubview(lable)
        
        let tv = LRUnselectableTappableTextView(frame: CGRect(x: 100, y: 400, width: 200, height: 200))
        let s = NSMutableParagraphStyle()
        s.lineSpacing = 3
        let atts = NSMutableAttributedString(string: lable.text!, attributes: [.foregroundColor: UIColor.red, .font: UIFont.systemFont(ofSize: 13, weight: .semibold), .baselineOffset: 3, .paragraphStyle: s])
        atts.addAttributes([.link: "any"], range: lable.text!.nsRange(of: "any"))
        atts.addAttributes([.link: "loading"], range: lable.text!.nsRange(of: "loading"))
        tv.attributedText = atts
        tv.linkColor = .black
        tv.tappedHandler = { text in
            print(text)
        }
        self.view.addSubview(tv)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

