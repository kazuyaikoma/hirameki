//
//  HistoryDetailViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2019/01/20.
//  Copyright © 2019 kaz. All rights reserved.
//

import UIKit
import Foundation
import Toast_Swift
import RealmSwift

class HistoryDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    var date: Date?
    var theme: String = ""
    var ideas: String = ""
    
    // キーボード入力時の下げ幅
    var keyboardOriginDiff: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // キーボード表示・非表示時のイベント登録
        NotificationCenter.default.addObserver(self, selector: #selector(HistoryDetailViewController.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HistoryDetailViewController.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.keyboardOriginDiff = self.view.frame.origin.y
        self.themeLabel.text = self.theme
        self.textView.text = self.ideas
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
            
            if let idea = ideas.filter("theme = '\(self.theme)'").first {
                try! realm.write { idea.setValue(self.textView.text ?? "", forKey: "ideas") }
            }
        } catch {
            print("realm error occurred at HistoryDetailVC#save")
        }
        
        self.makeSaveToast(toastInterval)
    }
    
    func makeSaveToast(_ duration: TimeInterval = 0.5) {
        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
