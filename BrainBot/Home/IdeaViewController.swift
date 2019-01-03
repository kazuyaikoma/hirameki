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
    @IBOutlet weak var throughButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    var designatedCount: Int?
    var currentIndex = 0
    var containerVC: IdeaPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed" {
            self.containerVC = segue.destination as? IdeaPageViewController
            self.containerVC?.designatedCount = self.designatedCount
            self.containerVC?.delegate = self
        }
    }
    
    func updateView() {
        guard let cnt = self.designatedCount else { return }
        let isFinal = (self.currentIndex >= cnt-1)
        
        UIView.animate(withDuration: 0.25) {
            self.throughButton.alpha = isFinal ? 0 : 1
            self.stopButton.alpha =    isFinal ? 0 : 1
            self.finishButton.alpha =  isFinal ? 1 : 0
            
            var x = CGFloat(self.currentIndex) * (self.progressBar.frame.width / CGFloat(cnt-1))
            // ページめくり始めでcurrentImgが不正にバックしないようにxを修正
            if x < 20 { x = 20 }
            self.currentImg.frame.origin.x = x
        }
    }
    
    @IBAction func onThroughTapped(_ sender: Any) {
        self.currentIndex += 1
        self.containerVC?.showNextPage(self.currentIndex)
        self.updateView()
    }
    
    @IBAction func onStopTapped(_ sender: Any) {
        // TODO: 完了後Viewの表示
    }
    
    @IBAction func onFinishTapped(_ sender: Any) {
        // TODO: 完了後Viewの表示
    }
    
    // MARK: - IdeaPageViewControllerDelegate
    
    func pageView(_ viewController: IdeaPageViewController, didChangedIndex index: Int) {
        self.currentIndex = index
        self.updateView()
    }
}


