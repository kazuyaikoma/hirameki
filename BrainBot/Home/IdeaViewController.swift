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
    @IBOutlet weak var finishButton: UIButton!
    
    var designatedCount: Int?
    var currentIndex = 0
    var containerVC: IdeaPageViewController?
    var finishBtnOriginFrame: CGRect?
    
    // 完了ボタンのAttributedString用のattributes
    let subAttrs: [NSAttributedString.Key : Any] = [
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue", size: 18.0) as Any
    ]
    let mainAttrs: [NSAttributedString.Key : Any] = [
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-Bold", size: 22.0) as Any
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 初回だけ終了ボタン用にsetup
        let subAttrStr = NSAttributedString(string: "中断して", attributes: self.subAttrs)
        let mainAttrStr = NSAttributedString(string: "完了", attributes: self.mainAttrs)
        let attrStr = NSMutableAttributedString()
        attrStr.append(subAttrStr)
        attrStr.append(mainAttrStr)
        self.finishButton.setAttributedTitle(attrStr, for: .normal)
        
        self.finishBtnOriginFrame = self.finishButton.frame
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed" {
            self.containerVC = segue.destination as? IdeaPageViewController
            self.containerVC?.designatedCount = self.designatedCount
            self.containerVC?.delegate = self
        }
    }
    
    @IBAction func onThroughTapped(_ sender: Any) {
        self.currentIndex += 1
        self.containerVC?.showNextPage(self.currentIndex)
        self.moveCurrentImg()
        self.changeViewState()
    }
    
    @IBAction func onFinishTapped(_ sender: Any) {
        // TODO: 完了後Viewの表示
    }
    
    // MARK: - IdeaPageViewControllerDelegate
    
    func pageView(_ viewController: IdeaPageViewController, didChangedIndex index: Int) {
        self.currentIndex = index
        
        self.moveCurrentImg()
        self.changeViewState()
    }
    
    func moveCurrentImg() {
        delay(0.3, callback: {
            UIView.animate(withDuration: 0.2) {
                guard let cnt = self.designatedCount else { return }
                var x = CGFloat(self.currentIndex) * (self.progressBar.frame.width / CGFloat(cnt-1))
                // ページめくり始めでcurrentImgが不正にバックしないようにxを修正
                if x < 20 { x = 20 }
                self.currentImg.frame.origin.x = x
            }
        })
    }
    
    func changeViewState() {
        var isFinal = false
        if let cnt = self.designatedCount, self.currentIndex >= cnt-1 {
            isFinal = true
        }
        // TODO: 完了ボタンの中断文言を抜き、矢印も対応
        
        UIView.animate(withDuration: 0.25) {
            self.throughButton.alpha = isFinal ? 0 : 1
            
            let subAttrStr = NSAttributedString(string: "中断して", attributes: self.subAttrs)
            let mainAttrStr = NSAttributedString(string: "完了", attributes: self.mainAttrs)
            let attrStr = NSMutableAttributedString()
            if !isFinal { attrStr.append(subAttrStr) }
            attrStr.append(mainAttrStr)
            self.finishButton.setAttributedTitle(attrStr, for: .normal)
            
            if isFinal {
                let addedWidth = self.finishButton.frame.minX - self.throughButton.frame.minX
                self.finishButton.frame.size.width += addedWidth
                self.finishButton.frame.origin.x = self.throughButton.frame.minX
            } else if let originFrame = self.finishBtnOriginFrame, self.finishButton.frame != originFrame {
                self.finishButton.frame = originFrame
            }
        }
    }
    
    func pageView(_ viewController: IdeaPageViewController, didChangedHint hint: String, text: String, index: Int) {
        // TODO: 必要そうなら実装, 不必要そうならdelegate methodごと削除
    }
}


