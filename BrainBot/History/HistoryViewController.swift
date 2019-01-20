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
    
    let cellId = "HistoryCell"
    
    var dates: [Date] = []
    var themes: [String] = []
    var ideas: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "履歴"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        let imageView = UIImageView(frame: self.tableView.frame)
        imageView.image = UIImage(named: "blue-yellow")
        self.tableView.backgroundView = imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
        self.tableView.reloadData()
        
        self.tableView.indexPathsForSelectedRows?.forEach {
            self.tableView.deselectRow(at: $0, animated: true)
        }
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
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailViewController") as? HistoryDetailViewController,
             let cell = tableView.cellForRow(at: indexPath) as? HistoryTableViewCell
        else { return }
        
        // TODO: 実装
        detailVC.navigationItem.title = "詳細"
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

