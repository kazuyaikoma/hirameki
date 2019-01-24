//
//  MenuViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/27.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "MenuCell"
    
    let titles: [String] = [
                            "アプリの使い方",
                            "コンセプト",
                            "アップデート予定"
                          ]
    
    let icons: [String] = [
                            "information",
                            "concept",
                            "update"
                          ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "設定"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idx = indexPath.row
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId) as? MenuTableViewCell,
            let image = UIImage(named: self.icons[idx]) {
            cell.update(title: self.titles[idx], icon: image)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MenuTableViewCell else {
            return
        }
        
        switch cell.title.text {
        case "アプリの使い方":
            // Onboarding画面の表示
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
            vc.isFirst = false
            self.present(vc, animated: true, completion: nil)
            return
        case "コンセプト":
            let vc = WebViewController()
            vc.urlString = "https://scrapbox.io/hirameki-app/コンセプト"
            self.show(vc, sender: nil)
        case "アップデート予定":
            let vc = WebViewController()
            vc.urlString = "https://scrapbox.io/hirameki-app/アップデート予定"
            self.show(vc, sender: nil)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
