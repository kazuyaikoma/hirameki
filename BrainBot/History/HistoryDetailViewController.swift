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
import LINEActivity

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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(HistoryDetailViewController.onSharePushed))
        
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
        self.makeSaveToast(toastInterval)
    }
    
    func makeSaveToast(_ duration: TimeInterval = 0.5) {
        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.makeToast(" 履歴に保存しました ✔︎ ", duration: 0.8, style: style)
    }
    
    @IBAction func onDeletePushed(_ sender: Any) {
        let alert = UIAlertController(title: "本当に削除しますか？", message: "このアイデアに関する入力内容は破棄されます", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.delete()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onRethinkPushed(_ sender: Any) {
        let alert = UIAlertController(title: "もう一度ヒラメキますか？", message: "これまで出したアイデアを引き継いで、もう一度考えます", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.rethink()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func delete() {
    }
    
    func onDeleteSucceeded() {
        var style = ToastStyle()
        style.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.makeToast(" 履歴から削除しました 🗑 ", duration: 0.4, position: .center, style: style)
        delay(0.45, callback: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func rethink() {
        guard let ideaVC = self.storyboard?.instantiateViewController(withIdentifier: "IdeaViewController") as? IdeaViewController else {
            return
        }
        
        ideaVC.navigationItem.title = self.theme
        ideaVC.oldIdeas = self.textView.text
        ideaVC.designatedCount = BBMaterial.hints.count / 2
        self.show(ideaVC, sender: nil)
    }
    
    @objc func onSharePushed() -> Void {
        let theme = "テーマ: " + (self.themeLabel.text ?? "")
        let idea = "アイデア: " + (self.textView.text ?? "")
        let text = theme + "\n" + idea
        
        let LineKit = LINEActivity()
        let activities = [LineKit]
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: activities)
        present(activityVC, animated: true, completion: nil)
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
