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
    func pageView(_ viewController: IdeaPageViewController, didChangedIndex index: Int)
}

class IdeaPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageVC: UIPageViewController!
    var hints = BBMaterial.hints
    // key: 質問文(hint), value: ユーザーからの回答
    var data: [String:String] = [:]
    var designatedCount: Int?
    
    var delegate: IdeaPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupData()
        self.setupPageVC()
    }
    
    func setupData() {
        guard let cnt = self.designatedCount else { return }
        
        self.hints.shuffle()
        if cnt <= hints.count-1 {
            self.hints.removeSubrange(cnt...hints.count-1)
        }
        
        for (idx, hint) in self.hints.enumerated() {
            self.data[hint] = ""
            if cnt <= idx { return }
        }
    }
    
    func setupPageVC() {
        self.pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageVC.dataSource = self
        self.pageVC.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = self.instantiateContentVC(storyboard, index: 0)
        
        self.pageVC.setViewControllers([vc], direction: .forward, animated: false, completion: {done in })
        self.pageVC.view.backgroundColor = UIColor.clear
        
        self.addChild(self.pageVC)
        self.view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParent: self)
    }
    
    func showNextPage(_ nextIndex: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = self.instantiateContentVC(storyboard, index: nextIndex)
        self.pageVC.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var number = (viewController as? IdeaContentViewController)?.number else {
            return nil
        }
        
        // 後方のViewControllerを生成するためカウントダウン
        number -= 1
        if number < 0 { return nil }

        return self.instantiateNextContentVC(viewController, number: number)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var number = (viewController as? IdeaContentViewController)?.number else {
            return nil
        }
        
        // 前方のViewControllerを生成するためカウントアップ
        number += 1
        if number >= hints.count { return nil }

        return self.instantiateNextContentVC(viewController, number: number)
    }
    
    func instantiateNextContentVC(_ viewController: UIViewController, number: Int) -> UIViewController {
        let storyboard = viewController.storyboard ?? UIStoryboard(name: "Main", bundle: nil)
        return self.instantiateContentVC(storyboard, index: number)
    }
    
    func instantiateContentVC(_ storyboard: UIStoryboard, index: Int) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: IdeaContentViewController = storyboard.instantiateViewController(withIdentifier: "IdeaContentViewController") as! IdeaContentViewController
        
        let hint = self.hints[index]
        vc.number = index
        vc.setHint(hint)
        vc.setIdea(self.data[hint] ?? "")
        
        vc.leftArrow.isHidden = (index == 0)
        vc.rightArrow.isHidden = (index == self.hints.count-1)
        
        return vc
    }
    
    func indexOfViewController(_ viewController: IdeaContentViewController) -> Int {
        let hint = viewController.getHint()
        return self.hints.firstIndex(of: hint ?? "") ?? NSNotFound
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.save()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed { return }
        guard let vc = pageViewController.viewControllers?.first as? IdeaContentViewController,
            let hintText = vc.hintLabel.text,
            let index = self.hints.firstIndex(of: hintText)
        else { return }
        
        self.delegate?.pageView(self, didChangedIndex: index)
    }
    
    func save() {
        guard let vc = self.pageVC.viewControllers?.first as? IdeaContentViewController,
            let hintText = vc.hintLabel.text,
            let ideaText = vc.ideaText.text
            else { return }
        
        self.data[hintText] = ideaText
    }
    
    func hideKeyboard() {
        guard let vc = self.pageVC.viewControllers?.first as? IdeaContentViewController
            else { return }
        
        vc.ideaText.resignFirstResponder()
    }
}
