//
//  HistoryTableViewCell.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2019/01/20.
//  Copyright © 2019 kaz. All rights reserved.
//

import Foundation
import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var theme: UILabel!
    @IBOutlet weak var idea: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(date: Date, theme: String, idea: String) {
        let yearFormatter = DateFormatter()
        let dateFormatter = DateFormatter()
        yearFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Yyyy", options: 0, locale: Locale(identifier: "en_US"))
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: Locale(identifier: "en_US"))
        
        self.year.text = yearFormatter.string(from: date)
        self.date.text = dateFormatter.string(from: date)
        
        self.theme.text = theme
        self.idea.text = idea
    }
}
