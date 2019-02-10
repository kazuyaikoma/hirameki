//
//  MenuTableViewCell.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2019/01/22.
//  Copyright © 2019 kaz. All rights reserved.
//

import Foundation

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func update(title: String, icon: UIImage) {
        self.title.text = title
        self.icon.image = icon
    }
}
