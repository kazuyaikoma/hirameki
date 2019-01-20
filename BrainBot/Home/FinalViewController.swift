//
//  FinalViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2019/01/04.
//  Copyright © 2019 kaz. All rights reserved.
//

import UIKit
import Foundation
import UICircularProgressRing
import Toast_Swift
import RealmSwift

class FinalViewController: UIViewController {
    @IBOutlet weak var progressCircle: UICircularProgressRing!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    // キーボード入力時の下げ幅
    var keyboardOriginDiff: CGFloat = 0
    
    // themeLabel用テキスト
    var themeTxt: String?
    
    // key: 質問文(hint), value: ユーザーからの回答
    var data: [String:String] = [:]
    // 回答数
    var count = 0
    // 回答率
    var percent: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressCircle.gradientColors = [UIColor.red, UIColor.blue]
        
        var ideas = ""
        for (_, idea) in self.data {
            if idea.isEmpty { continue }
            let str = idea.replacingOccurrences(of: "\n", with: "\n - ")
            ideas += "\n - " + str
            self.count += 1
        }
        
        self.percent = round(CGFloat(self.count) / CGFloat(self.data.count) * 100)
        
        let idx = Int(self.percent) / 21
        self.message.text = BBMaterial.messages[idx]
        self.textView.text = ideas
        
        // キーボード表示・非表示時のイベント登録
        NotificationCenter.default.addObserver(self, selector: #selector(FinalViewController.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FinalViewController.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardOriginDiff = self.view.frame.origin.y
        self.themeLabel.text = self.themeTxt
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.progressCircle.startProgress(to: self.percent, duration: 1.0)
        
        self.save(1.2)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // textView以外の部分をタッチした場合に非表示にする
        if let text = self.textView, text.isFirstResponder {
            text.resignFirstResponder()
        }
    }
    
    func save(_ toastInterval: TimeInterval = 0.5) {
        do {
            let realm = try Realm()
            let ideas = realm.objects(Idea.self)
            
            if let theme = self.themeTxt, let idea = ideas.filter("theme = '\(theme)'").first {
                try! realm.write { idea.setValue(self.textView.text ?? "", forKey: "ideas") }
            } else {
                let idea = Idea(value: ["updatedDate": Date.init(), "theme": self.themeTxt ?? "", "ideas": self.textView.text ?? ""])
                try! realm.write { realm.add(idea) }
            }
        } catch {
            print("realm error occurred at FinalVC#save")
        }
        
        self.makeSaveToast(toastInterval)
    }
    
    func makeSaveToast(_ duration: TimeInterval = 0.5) {
        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.makeToast(" 履歴に保存しました ✔︎ ", duration: 0.8, style: style)
    }
    
    // MARK: - NotificationCenter
    
    @objc func keyboardWillChange(_ notification: Foundation.Notification) {
        guard let info = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey])?.cgRectValue,
            let duration: Double = (info[UIResponder.keyboardAnimationDurationUserInfoKey])?.doubleValue
            else { return }
        
        // キーボードに被らないように
        let options = UIView.AnimationOptions(rawValue: UInt((info[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
        let after = {() -> Void in
            let diff = keyboardFrame.origin.y - UIScreen.main.bounds.size.height
            if diff < 0 {
                self.view.frame.origin.y = -40
            } else {
                self.view.frame.origin.y = self.keyboardOriginDiff
            }
        }
        
        UIView.animate(
            withDuration: duration,
            delay:0.0,
            options:options,
            animations: after,
            completion: nil
        )
    }
    
    @objc func keyboardDidHide(_ notification: Foundation.Notification) {
        self.save()
    }
}
