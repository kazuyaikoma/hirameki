//
//  Idea.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2019/01/15.
//  Copyright © 2019 kaz. All rights reserved.
//

import Foundation
import RealmSwift

class Idea: Object {
    @objc dynamic var updatedDate: Date = Date.init()
    @objc dynamic var theme: String = ""
    @objc dynamic var ideas: String = ""
}
