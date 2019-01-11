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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressCircle.gradientColors = [UIColor.red, UIColor.blue]
        self.themeLabel.numberOfLines = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: 完成度を修正
        self.progressCircle.startProgress(to: 100, duration: 2.0)
    }
    
}
