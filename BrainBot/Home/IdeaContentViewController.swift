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
    @IBOutlet weak var ideaText: UITextView!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var rightArrow: UIImageView!
    var number: Int?
    // キーボード入力時の下げ幅
    var keyboardOriginDiff: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // キーボード表示・非表示時のイベント登録
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(IdeaContentViewController.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardOriginDiff = self.view.frame.origin.y
    }
    
    // TODO: FIX: 以下の4つメソッド、subviewsから取得してしまっているが、本来はIBOutlet接続してるUILabelを直接そのまま扱いたい。
    // しかしこの時点で評価するとなぜかnilになる
    func setHint(_ hint: String) {
        ((self.view.subviews.first?.subviews.filter({ $0 is UILabel }).first) as? UILabel)?.text = hint
    }
    
    func getHint() -> String? {
        return ((self.view.subviews.first?.subviews.filter({ $0 is UILabel }).first) as? UILabel)?.text
    }
    
    func setIdea(_ idea: String) {
        ((self.view.subviews.filter({ $0 is UITextView }).first) as? UITextView)?.text = idea
    }
    
    func getIdea() -> String? {
        return ((self.view.subviews.filter({ $0 is UITextView }).first) as? UITextView)?.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // ideaText以外の部分をタッチした場合に非表示にする
        if let label = self.ideaText, label.isFirstResponder {
            label.resignFirstResponder()
        }
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
                self.view.frame.origin.y = -30
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
}
