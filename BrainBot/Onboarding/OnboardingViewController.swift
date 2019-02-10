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
    @IBOutlet weak var nonFirstArea: UIView!
    
    var isFirst = true
    var parentVC: UIViewController?
    
    static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    static let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
    
    static let firstImg = UIImage(named: "onboarding-first") ?? UIImage(named: "idea")!
    static let secondImg = UIImage(named: "onboarding-second") ?? UIImage(named: "idea")!
    static let thirdImg = UIImage(named: "onboarding-third") ?? UIImage(named: "idea")!
    static let firstNumImg = UIImage(named: "one") ?? UIImage(named: "idea")!
    static let secondNumImg = UIImage(named: "two") ?? UIImage(named: "idea")!
    static let thirdNumImg = UIImage(named: "three") ?? UIImage(named: "idea")!
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: OnboardingViewController.firstImg,
                           title: "１. テーマを決める",
                           description: "「田舎の自販機を売れるようにしたい」\nだったり、\n「イベントになんとか100人集めたい」\nだったり。\nあなたは何をヒラメキたい？",
                           pageIcon: OnboardingViewController.firstNumImg,
                           color: BBColor.red,
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: OnboardingViewController.titleFont, descriptionFont: OnboardingViewController.descriptionFont),
        
        OnboardingItemInfo(informationImage: OnboardingViewController.secondImg,
                           title: "２. ひらめく",
                           description: "決めたテーマについて、\nアプリの質問に答えながら一人ブレスト。\n画期的なアイデアが生まれるはず。",
                           pageIcon: OnboardingViewController.secondNumImg,
                           color: BBColor.yellow,
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: OnboardingViewController.titleFont, descriptionFont: OnboardingViewController.descriptionFont),
        
        OnboardingItemInfo(informationImage: OnboardingViewController.thirdImg,
                           title: "３. シェア",
                           description: "ひらめいたアイデアを、\n仲間とLINEやSlack、twitter等でシェア。\nさらにアイデアが膨らむかも。",
                           pageIcon: OnboardingViewController.thirdNumImg,
                           color: BBColor.blue,
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: OnboardingViewController.titleFont, descriptionFont: OnboardingViewController.descriptionFont),
        
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startButton.isHidden = true
        self.nonFirstArea.isHidden = true
        
        setupPaperOnboardingView()
        
        view.bringSubviewToFront(self.startButton)
        view.bringSubviewToFront(self.nonFirstArea)
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
                                                toItem: self.view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    @IBAction func onStartTapped(_: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onOkTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDetailTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            let vc = WebViewController()
            vc.urlString = "https://scrapbox.io/hirameki-app/アプリの使い方"
            if let menuVC = self.parentVC as? MenuViewController {
                menuVC.show(vc, sender: nil)
            }
        })
    }
    
    // MARK: PaperOnboardingDelegate
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        let isFinal = index == 2
        if self.isFirst {
            self.startButton.isHidden = !isFinal
        } else {
            self.nonFirstArea.isHidden = !isFinal
        }
    }
    
    func onboardingDidTransitonToIndex(_: Int) {
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
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
        return [BBColor.red, BBColor.yellow, BBColor.blue][index]
    }
}

