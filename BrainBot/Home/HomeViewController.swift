//
//  HomeViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/27.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var themeText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "アイデア"
        
    }

    @IBAction func onStartTapped(_ sender: Any) {
        if let ideaVC = self.storyboard?.instantiateViewController(withIdentifier: "IdeaViewController") {
            ideaVC.navigationItem.title = themeText.text
            self.show(ideaVC, sender: sender)
        }
    }
}

