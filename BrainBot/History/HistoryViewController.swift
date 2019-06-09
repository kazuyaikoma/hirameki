//
//  HistoryViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/27.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noHistoryView: UILabel!
    
    let cellId = "HistoryCell"
    
    var dates: [Date] = []
    var themes: [String] = []
    var ideas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "履歴"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: self.cellId)
        
        let imageView = UIImageView(frame: self.tableView.frame)
        imageView.image = UIImage(named: "blue-yellow")
        self.tableView.backgroundView = imageView
        self.tableView.contentInset.top = 8
        self.tableView.contentInset.bottom = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
        self.noHistoryView.isHidden = !self.dates.isEmpty
        self.tableView.reloadData()
    }
    
    func reloadData() {
        self.dates = []
        self.themes = []
        self.ideas = []
        
        do {
            let realm = try Realm()
            let datas = realm.objects(Idea.self).sorted(byKeyPath: "updatedDate", ascending: false)
            for data in datas {
                self.dates.append(data.updatedDate)
                self.themes.append(data.theme)
                self.ideas.append(data.ideas)
            }
        } catch {
            print("realm error occurred at HistoryViewController#viewWillAppear")
        }
    }

    // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellId) as! HistoryTableViewCell
        let idx = indexPath.row
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.update(date: self.dates[idx], theme: self.themes[idx], idea: self.ideas[idx])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailViewController") as? HistoryDetailViewController
        else { return }
        let idx = indexPath.row
        
        detailVC.navigationItem.title = "詳細"
        detailVC.date = self.dates[idx]
        detailVC.theme = self.themes[idx]
        detailVC.ideas = self.ideas[idx]
        self.show(detailVC, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? HistoryTableViewCell else {
            return
        }
        cell.changeHighlight(true)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? HistoryTableViewCell else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            cell.changeHighlight(false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

