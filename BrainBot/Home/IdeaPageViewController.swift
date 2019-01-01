//
//  IdeaPageViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/31.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit
import Foundation

protocol IdeaPageViewControllerDelegate {
    func pageView(_ viewController: IdeaPageViewController, didChangedHint hint: String, text: String, index: Int)
}

class IdeaPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageVC: UIPageViewController!
    var hints = BBMaterial.hints
    // key: 質問文(hint), value: ユーザーからの回答
    var data: [String:String] = [:]
    
    var delegate: IdeaPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupData()
        self.setupPageVC()
    }
    
    func setupData() {
        self.hints.shuffle()
        
        for hint in self.hints {
            self.data[hint] = ""
        }
    }
    
    func setupPageVC() {
        self.pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageVC.dataSource = self
        self.pageVC.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: IdeaContentViewController = storyboard.instantiateViewController(withIdentifier: "IdeaContentViewController") as! IdeaContentViewController
        
        vc.number = 0
        vc.setHint(self.hints[0])
        
        self.pageVC.setViewControllers([vc], direction: .forward, animated: false, completion: {done in })
        self.pageVC.view.backgroundColor = UIColor.clear
        
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParent: self)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var number = (viewController as? IdeaContentViewController)?.number else {
            return nil
        }
        
        // 後方のViewControllerを生成するためカウントダウン
        number -= 1
        if number < 0 { return nil }

        return self.instantiateNextVC(viewController, number: number)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var number = (viewController as? IdeaContentViewController)?.number else {
            return nil
        }
        
        // 前方のViewControllerを生成するためカウントアップ
        number += 1
        if number >= hints.count { return nil }

        return self.instantiateNextVC(viewController, number: number)
    }
    
    func instantiateNextVC(_ viewController: UIViewController, number: Int) -> UIViewController {
        let vc = viewController.storyboard?.instantiateViewController(withIdentifier: "IdeaContentViewController") as! IdeaContentViewController
        let hint = self.hints[number]
        
        vc.number = number
        vc.setHint(hint)
        vc.setIdea(self.data[hint] ?? "")
        return vc
    }
    
    func indexOfViewController(_ viewController: IdeaContentViewController) -> Int {
        let hint = viewController.getHint()
        return self.hints.firstIndex(of: hint ?? "") ?? NSNotFound
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed { return }
        
        guard let vc = pageViewController.viewControllers!.first as? IdeaContentViewController,
            let hintText = vc.hintLabel.text,
            let ideaText = vc.ideaText.text,
            let index = self.hints.firstIndex(of: hintText)
        else {
            return
        }
        
        self.data[hintText] = ideaText
        self.delegate?.pageView(self, didChangedHint: hintText, text: ideaText, index: index)
    }
}
