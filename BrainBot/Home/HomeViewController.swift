//
//  HomeViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/27.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit
import fluid_slider
import RealmSwift

class HomeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var themeText: UITextField!
    @IBOutlet weak var countTextArea: UIView!
    @IBOutlet weak var countText: UILabel!
    @IBOutlet weak var slider: Slider!
    
    var currentFraction: Int = Int(floor(Double(BBMaterial.hints.count) / 2.0))
    // キーボード入力時の下げ幅
    var keyboardOriginDiff: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "ヒラメキ"
        self.themeText.attributedPlaceholder = NSAttributedString(string: "例：田舎の自販機を売れるようにする方法", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.7)])
        self.themeText.delegate = self
        
        // キーボード表示・非表示時のイベント登録
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomeViewController.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        self.countText.text = String(self.currentFraction)
        self.setupSlider()
        
        self.showOnboardingForFirst()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardOriginDiff = self.view.frame.origin.y
    }
    
    func setupSlider() {
        let hintsCnt = BBMaterial.hints.count
        self.slider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 2
            formatter.maximumFractionDigits = 0
            var string = formatter.string(from: (fraction * CGFloat(hintsCnt)) as NSNumber) ?? ""
            if string == "0" || string == "1" { string = "2" }       // 0又は1は、2に変換
            let strAttrsForFraction: [NSAttributedString.Key : Any] = [
                .foregroundColor: BBColor.blue,
                .font: UIFont(name: "HelveticaNeue-Bold", size: 20.0) as Any
            ]
            return NSAttributedString(string: string, attributes: strAttrsForFraction)
        }
        
        let strAttrs: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue", size: 18.0) as Any
        ]
        
        self.slider.setMinimumLabelAttributedText(NSAttributedString(string: "2", attributes: strAttrs))
        self.slider.setMaximumLabelAttributedText(NSAttributedString(string: "\(hintsCnt)", attributes: strAttrs))
        self.slider.fraction = 0.5
        self.slider.shadowOffset = CGSize(width: 0, height: 10)
        self.slider.shadowBlur = 5
        self.slider.contentViewColor = BBColor.blue
        self.slider.valueViewColor = UIColor.white
        
        self.slider.didBeginTracking = { slider in
            // countTextAreaを隠す
            UIView.animate(withDuration: 0.25) {
                self.countTextArea.alpha = 0
            }
        }
        
        self.slider.didEndTracking = { slider in
            let fracStr = slider.attributedTextForFraction(slider.fraction).string
            var fraction = Int(fracStr)
            // 0又は1は、2に変換
            if fraction == 0 || fraction == 1 { fraction = 2 }
            if let f = fraction { self.currentFraction = f }
            
            // countTextAreaを表示
            self.countText.text = String(self.currentFraction)
            UIView.animate(withDuration: 0.25) {
                self.countTextArea.alpha = 1
            }
        }
    }

    @IBAction func onStartTapped(_ sender: Any) {
        guard let ideaVC = self.storyboard?.instantiateViewController(withIdentifier: "IdeaViewController") as? IdeaViewController,
        let theme = self.themeText.text
        else { return }
        
        self.checkValid(theme: theme)
        
        ideaVC.navigationItem.title = theme
        ideaVC.designatedCount = self.currentFraction
        self.show(ideaVC, sender: sender)
    }
    
    func showOnboardingForFirst() {
        let userDefault = UserDefaults.standard
        let dict = ["firstLaunch": true]
        userDefault.register(defaults: dict)
        
        // 初回起動時のみ実行
        if userDefault.bool(forKey: "firstLaunch") {
            // Onboarding画面の表示
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
            self.present(vc, animated: true, completion: {
                userDefault.set(false, forKey: "firstLaunch")
            })
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle:  UIAlertController.Style.alert)
        let action = UIAlertAction(title: "確認", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkValid(theme: String) {
        if theme.isEmpty {
            self.showAlert("思いつきたいテーマを上の空欄に入力してください")
            return
        }
        
        do {
            let realm = try Realm()
            let ideas = realm.objects(Idea.self)
            if let _ = ideas.filter("theme = '\(theme)'").first {
                self.showAlert("すでに同じテーマのアイデアが存在します。「履歴」からヒラメクことができます。")
            }
        } catch {
            print("realm error occurred at HomeVC#onStartTapped")
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
}
