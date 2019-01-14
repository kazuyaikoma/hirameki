//
//  FinalViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2019/01/04.
//  Copyright © 2019 kaz. All rights reserved.
//

import UIKit
import Foundation
import UICircularProgressRing

class FinalViewController: UIViewController {
    @IBOutlet weak var progressCircle: UICircularProgressRing!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var data: [String:String] = [:]
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressCircle.gradientColors = [UIColor.red, UIColor.blue]
        self.themeLabel.numberOfLines = 0
        
        var ideas = ""
        for (_, idea) in self.data {
            if idea.isEmpty { continue }
            let str = idea.replacingOccurrences(of: "\n", with: "\n - ")
            ideas += "\n - " + str
            self.count += 1
        }
        
        self.textView.text = ideas
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let percent = round(CGFloat(self.count) / CGFloat(self.data.count) * 100)
        self.progressCircle.startProgress(to: percent, duration: 1.5)
    }
    
}
