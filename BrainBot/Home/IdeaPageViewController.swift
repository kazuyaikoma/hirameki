//
//  IdeaPageViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/31.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit

class IdeaPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.isUserInteractionEnabled = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "IdeaContentViewController") as UIViewController
        self.pageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: {done in })
        self.pageViewController.view.backgroundColor = UIColor.clear
        
//        self.addChildViewController(pageViewController)
        self.view.addSubview(self.pageViewController.view)
//        pageViewController.didMove(toParentViewController: self)
    }
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // TODO: 実装
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // TODO: 実装
        return nil
    }
    
    
}
