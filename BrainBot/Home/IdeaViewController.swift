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
    
    func pageView(_ viewController: IdeaPageViewController, didChangedText text: String, atIndex index: Int) {
        print("a")
        // TODO: 実装
    }
}


