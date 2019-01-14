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
        
        // 戻るボタン
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(IdeaViewController.onBackPushed))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        // エッジスワイプ無効化
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        self.showFinalView(sender)
    }
    
    @IBAction func onFinishTapped(_ sender: Any) {
        self.showFinalView(sender)
    }
    
    func showFinalView(_ sender: Any) {
        if let finalVC = self.storyboard?.instantiateViewController(withIdentifier: "FinalViewController") as? FinalViewController {
            finalVC.navigationItem.title = self.navigationItem.title
            finalVC.data = containerVC?.data ?? [:]
            self.show(finalVC, sender: sender)
        }
    }
    
    @objc func onBackPushed() -> Void {
        let alert: UIAlertController = UIAlertController(title: "本当に戻りますか？", message: "これまでの入力内容は破棄されます", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            return
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IdeaPageViewControllerDelegate
    
    func pageView(_ viewController: IdeaPageViewController, didChangedIndex index: Int) {
        self.currentIndex = index
        self.updateView()
    }
}


