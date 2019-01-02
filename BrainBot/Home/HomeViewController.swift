//
//  HomeViewController.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2018/12/27.
//  Copyright © 2018 kaz. All rights reserved.
//

import UIKit
import fluid_slider

class HomeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var themeText: UITextField!
    @IBOutlet weak var sliderArea: UIView!
    @IBOutlet weak var countTextArea: UIView!
    @IBOutlet weak var countText: UILabel!
    
    var slideBar: Slider?
    var currentFraction: Int = Int(round(Double(BBMaterial.hints.count) / 2.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "アイデア"
        
        // キーボード表示・非表示時のイベント登録
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomeViewController.keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.countText.text = String(self.currentFraction)
        self.setupSlider()
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
    
    func setupSlider() {
        let hintsCnt = BBMaterial.hints.count
        let slider = Slider()
        slider.frame = self.sliderArea.frame
        slider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 2
            formatter.maximumFractionDigits = 0
            var string = formatter.string(from: (fraction * CGFloat(hintsCnt)) as NSNumber) ?? ""
            if string == "0" { string = "1" }       // 0は1に変換
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
        
        slider.setMinimumLabelAttributedText(NSAttributedString(string: "1", attributes: strAttrs))
        slider.setMaximumLabelAttributedText(NSAttributedString(string: "\(hintsCnt)", attributes: strAttrs))
        slider.fraction = 0.5
        slider.shadowOffset = CGSize(width: 0, height: 10)
        slider.shadowBlur = 5
        slider.contentViewColor = BBColor.blue
        slider.valueViewColor = UIColor.white
        
        slider.didBeginTracking = { slider in
            // countTextAreaを隠す
            UIView.animate(withDuration: 0.25) {
                self.countTextArea.alpha = 0
            }
        }
        
        slider.didEndTracking = { slider in
            let fracStr = slider.attributedTextForFraction(slider.fraction).string
            var fraction = Int(fracStr)
            // 0は1に変換
            if fraction == 0 { fraction = 1 }
            if let f = fraction { self.currentFraction = f }
            
            // countTextAreaを表示
            self.countText.text = String(self.currentFraction)
            UIView.animate(withDuration: 0.25) {
                self.countTextArea.alpha = 1
            }
        }
        
        self.view.addSubview(slider)
    }

    @IBAction func onStartTapped(_ sender: Any) {
        if let ideaVC = self.storyboard?.instantiateViewController(withIdentifier: "IdeaViewController") as? IdeaViewController {
            ideaVC.navigationItem.title = themeText.text
            ideaVC.designatedCount = self.currentFraction
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
