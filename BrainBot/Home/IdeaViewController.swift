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
    
    // MARK: - IdeaPageViewControllerDelegate
    
    func pageView(_ viewController: IdeaPageViewController, didChangedIndex index: Int) {
        UIView.animate(withDuration: 0.25) {
            var x = CGFloat(index) * (self.progressBar.frame.width / CGFloat(BBMaterial.hints.count-1))
            // ページめくり始めでcurrentImgが不正にバックしないようにxを修正
            if x < 20 { x = 20 }
            self.currentImg.frame.origin.x = x
        }
    }
    
    func pageView(_ viewController: IdeaPageViewController, didChangedHint hint: String, text: String, index: Int) {
        // TODO: 必要そうなら実装, 不必要そうならdelegate methodごと削除
    }
}


