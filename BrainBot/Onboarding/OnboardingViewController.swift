//
//  OnboardingViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2019/01/25.
//  Copyright © 2019 kaz. All rights reserved.
//

import Foundation
import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController, PaperOnboardingDelegate, PaperOnboardingDataSource {
    
    @IBOutlet var startButton: UIButton!
    
    static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "share")!,
                           title: "Hotels",
                           description: "All hotels and hostels are sorted by hospitality rating",
                           pageIcon: UIImage(named: "share")!,
                           color: BBColor.red,
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: OnboardingViewController.titleFont, descriptionFont: OnboardingViewController.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "share")!,
                           title: "Banks",
                           description: "We carefully verify all banks before add them into the app",
                           pageIcon: UIImage(named: "share")!,
                           color: BBColor.yellow,
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: OnboardingViewController.titleFont, descriptionFont: OnboardingViewController.descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "share")!,
                           title: "Stores",
                           description: "All local stores are categorized for your convenience",
                           pageIcon: UIImage(named: "share")!,
                           color: BBColor.blue,
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: OnboardingViewController.titleFont, descriptionFont: OnboardingViewController.descriptionFont),
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isHidden = true
        
        setupPaperOnboardingView()
        
        view.bringSubviewToFront(startButton)
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    @IBAction func onStartTapped(_: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: PaperOnboardingDelegate
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        startButton.isHidden = index == 2 ? false : true
    }
    
    func onboardingDidTransitonToIndex(_: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
    }
    
    // MARK: PaperOnboardingDataSource
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardinPageItemRadius() -> CGFloat {
        return 2
    }
    
    func onboardingPageItemSelectedRadius() -> CGFloat {
        return 10
    }
    
    func onboardingPageItemColor(at index: Int) -> UIColor {
        return [UIColor.white, UIColor.red, UIColor.green][index]
    }
}

