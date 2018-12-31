//
//  IdeaPageViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/31.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit

class IdeaPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageVC: UIPageViewController!
    var hints = BBMaterial.hints
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hints.shuffle()
        
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

        let vc = viewController.storyboard?.instantiateViewController(withIdentifier: "IdeaContentViewController") as! IdeaContentViewController
        vc.number = number
        vc.setHint(self.hints[number])
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var number = (viewController as? IdeaContentViewController)?.number else {
            return nil
        }
        
        // 前方のViewControllerを生成するためカウントアップ
        number += 1
        if number >= hints.count { return nil }

        let vc = viewController.storyboard?.instantiateViewController(withIdentifier: "IdeaContentViewController") as! IdeaContentViewController
        vc.number = number
        vc.setHint(self.hints[number])
        return vc
    }
    
    func indexOfViewController(_ viewController: IdeaContentViewController) -> Int {
        let hint = viewController.getHint()
        return self.hints.firstIndex(of: hint ?? "") ?? NSNotFound
    }
}
