//
//  IdeaViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/31.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit
import Foundation

class IdeaViewController: UIViewController, IdeaPageViewControllerDelegate {
    @IBOutlet weak var currentImg: UIImageView!
    @IBOutlet weak var progressBar: UIView!
    
    var containerVC: IdeaPageViewController?
    var progWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tODO: 質問数に応じてprogressBarの長さを割る
        self.progWidth = progressBar.frame.width / (3-1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed" {
            self.containerVC = segue.destination as? IdeaPageViewController
            self.containerVC?.delegate = self
        }
    }
    
    func pageView(_ viewController: IdeaPageViewController, didChangedHint hint: String, text: String, index: Int) {
        UIView.animate(withDuration: 0.25) {
            self.currentImg.frame.origin.x = (index == 0) ? 20 : CGFloat(index) * self.progWidth
        }
    }
}


