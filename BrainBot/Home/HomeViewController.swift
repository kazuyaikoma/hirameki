//
//  HomeViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/27.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var themeText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "アイデア"
        
        // キーボード表示・非表示時のイベント登録
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomeViewController.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // キーボード起動ぞ状態を解除
        let after = {() -> Void in
            self.view.frame.origin.y = 0
            self.themeText.resignFirstResponder()
        }
        
        delay(0.3, callback: {
            UIView.animate(withDuration: 0.2, delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseOut,
                           animations: after,
                           completion: nil
            )
        })
    }

    @IBAction func onStartTapped(_ sender: Any) {
        if let ideaVC = self.storyboard?.instantiateViewController(withIdentifier: "IdeaViewController") {
            ideaVC.navigationItem.title = themeText.text
            self.show(ideaVC, sender: sender)
        }
    }
    
    // 改行ボタンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを隠す
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // themeText以外の部分をタッチした場合に非表示にする
        if self.themeText.isFirstResponder {
            self.themeText.resignFirstResponder()
        }
    }
    
    // MARK: - NotificationCenter
    
    @objc func keyboardWillChange(_ notification: Foundation.Notification) {
        var info = notification.userInfo as! [String: AnyObject]
        let keyboardFrame = (info[UIResponder.keyboardFrameEndUserInfoKey])!.cgRectValue
        
        // キーボードに被らないように
        let duration: TimeInterval? = (info[UIResponder.keyboardAnimationDurationUserInfoKey]!).doubleValue
        let options = UIView.AnimationOptions(rawValue: UInt((info[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
        let after = {() -> Void in
            let diff = keyboardFrame!.origin.y - UIScreen.main.bounds.size.height
            if diff < 0 {
                self.view.frame.origin.y = -100
            } else {
                self.view.frame.origin.y = 0
            }
        }
        
        UIView.animate(
            withDuration: duration!,
            delay:0.0,
            options:options,
            animations: after,
            completion: nil
        )
    }
}

