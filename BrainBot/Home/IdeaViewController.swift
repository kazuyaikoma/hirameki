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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: 実装
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed" {
            self.containerVC = segue.destination as? IdeaPageViewController
            self.containerVC?.delegate = self
        }
    }
    
    func pageView(_ viewController: IdeaPageViewController, didChangedIndex index: Int) {
        UIView.animate(withDuration: 0.25) {
            self.currentImg.frame.origin.x = (index == 0) ? 20 : CGFloat(index) * (self.progressBar.frame.width / (3-1))
        }
    }
    
    func pageView(_ viewController: IdeaPageViewController, didChangedHint hint: String, text: String, index: Int) {
        // TODO: 必要そうなら実装, 不必要そうならdelegate methodごと削除
    }
}


