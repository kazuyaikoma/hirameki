//
//  IdeaContentViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/31.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit

class IdeaContentViewController: UIViewController {
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var ideaText: UITextField!
    var number: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: 実装
    }
    
    func setHint(_ hint: String) {
        // TODO: FIX: subviewsから取得してしまっているが、本来はIBOutlet接続してるUILabelを直接そのまま扱いたい。しかしこの時点で評価するとなぜかnilになる
        (self.view.subviews.first as? UILabel)?.text = hint
    }
    
    func getHint() -> String? {
        // ここもsetHintと同じ課題
        // TODO: FIX: subviewsから取得してしまっているが、本来はIBOutlet接続してるUILabelを直接そのまま扱いたい。しかしこの時点で評価するとなぜかnilになる
        return (self.view.subviews.first as? UILabel)?.text
    }
}
