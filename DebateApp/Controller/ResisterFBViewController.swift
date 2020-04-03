//
//  ViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/02.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit


class ResisterFBViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    

    @IBOutlet weak var doneButton: UIButton!
    //モーションを表示するLabel
    @IBOutlet weak var motionLabel: UILabel!
    //モーションを入力するTextField
    @IBOutlet weak var motionTextField: UITextField!
    
    
    
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var WLLabel: UILabel!
    
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreTextField: UITextField!
    

    
    @IBOutlet weak var FBTextView: UITextView!
    var NumberOfButtons: Int = 2  //ボタンの数
    
    var CheckedWLButtonTag = 0  //チェックされているボタンのタグ
    var CheckedStyleButtonTag = 10
    //それぞれ画像を読み込む
    let checkedImage = UIImage(named: "checkOn")! as UIImage
    let uncheckedImage = UIImage(named: "checkOff")! as UIImage
    
    let WLList = ["勝ち", "負け"]
    let styleList = ["NA", "BP", "Asian"]
    
    var WLString:String!
    var styleString:String!
    let center = Int(UIScreen.main.bounds.size.width / 2)
    
    var WLButtonArray = [UIButton]()
    var styleButtonArray = [UIButton]()
    
    
    
    var pickerView: UIPickerView = UIPickerView()
    var scoreList = ["65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82",                    "83", "84", "85"]
    var score:String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionTextField.delegate = self
        FBTextView.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([doneItem], animated: true)
        
        scoreTextField.inputView = pickerView
        scoreTextField.inputAccessoryView = toolBar
        
        WLLabel.frame = CGRect(x: center - 170, y: 200, width: 80, height: 30)
        styleLabel.frame = CGRect(x: center + 10, y: 200, width: 80, height: 30)
        
        scoreLabel.frame = CGRect(x: center - 170, y: 340, width: 60, height: 30)
        scoreTextField.frame = CGRect(x: center - 100, y: 340, width: 40, height: 30)
        

        
        FBTextView.layer.borderColor = UIColor.black.cgColor
        FBTextView.layer.borderWidth = 1.0
        
        doneButton.tag = 100
        motionLabel.numberOfLines = 3
        
        for i in 0..<WLList.count {
            set_WLRadioButton(num: i)
        }
     
        print(self.view!)
        
        for i in 0..<styleList.count {
            set_styleRadioButton(num: i)
        }
    
    }
    
    
    //TextFieldの文字をLabelに反映
    @IBAction func motionDecide(_ sender: Any) {
        print("button was pushed")
        
        if motionTextField.text == ""{
            print("no content")
            motionLabel.text = "無題"
        } else {
            motionLabel.text = motionTextField.text!
        }
        
        //キーボード閉じる
        motionTextField.resignFirstResponder()
    }
    

    //ラジオボタン(勝敗)を配置する
    func set_WLRadioButton(num:Int){
        let button = UIButton()
       //中央の位置
        let y = 240+45*num  //ボタン同士が重ならないようyを調整
        button.setImage(uncheckedImage, for: .normal)
        button.addTarget(self, action: #selector(WLButttonClicked(_:)), for: .touchUpInside)
        button.frame = CGRect(x: center - 170,y: y,
                              width: 30,height: 30)
        button.tag = num
        
        self.view.addSubview(button)
        WLButtonArray.append(button)
        
        
        let label = UILabel()
        label.text = WLList[num]
        label.frame = CGRect(x: center - 130,y: y,
                              width: 70,height: 30)
       
        self.view.addSubview(label)
        
    
    }
    
    //ラジオボタン(スタイル)を配置する
    func set_styleRadioButton(num:Int){
        let button = UIButton()
        let center = Int(UIScreen.main.bounds.size.width / 2)  //中央の位置
        let y = 240+45*num  //ボタン同士が重ならないようyを調整
        button.setImage(uncheckedImage, for: .normal)
        button.addTarget(self, action: #selector(styleButttonClicked(_:)), for: .touchUpInside)
        button.frame = CGRect(x: center + 20,y: y,
                              width: 30,height: 30)
        button.tag = num + 10
        self.view.addSubview(button)
        styleButtonArray.append(button)
        
        let label = UILabel()
        label.text = styleList[num]
        label.frame = CGRect(x: center + 60,y: y,
                              width: 70,height: 30)
        self.view.addSubview(label)
    
    }

    //押されたボタンの画像をcheck_on.pngに変える(勝敗)
    @objc func WLButttonClicked(_ sender: UIButton) {
        ChangeToUncheckedWL(num: CheckedWLButtonTag)
        let button = sender
        button.setImage(checkedImage, for: .normal)
        CheckedWLButtonTag = button.tag  //check_on.pngになっているボタンのtagを更新
        WLString = WLList[CheckedWLButtonTag]
        print("checkd: ", WLString!)
  
    }
    
    //押されたボタンの画像をcheck_on.pngに変える(スタイル)
    @objc func styleButttonClicked(_ sender: UIButton) {
        ChangeToUncheckedStyle(num: CheckedStyleButtonTag)
        let button = sender
        button.setImage(checkedImage, for: .normal)
        CheckedStyleButtonTag = button.tag  //check_on.pngになっているボタンのtagを更新
        styleString = styleList[CheckedStyleButtonTag - 10]
        print("checkd: ", styleString!)

    }

    //すでにcheck_on.pngになっているボタンの画像をcheck_off.pngに変える
    func ChangeToUncheckedWL(num:Int){
        for v in WLButtonArray {
            if let v = v as? UIButton, v.tag == num {
                print("v.tag:", v.tag)
                v.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    //すでにcheck_on.pngになっているボタンの画像をcheck_off.pngに変える
    func ChangeToUncheckedStyle(num:Int){
        for v in styleButtonArray {
            if let v = v as? UIButton, v.tag == num {
                print("v.tag:", v.tag)
                v.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    //入力画面ないしkeyboardの外を押したら、キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.FBTextView.isFirstResponder) {
            self.FBTextView.resignFirstResponder()
        }
        
        if (self.motionTextField.isFirstResponder) {
            self.motionTextField.resignFirstResponder()
        }
    }
    
    //returnしたらキーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //テキストフィールドを閉じる
        motionTextField.resignFirstResponder()
        return true
    }
    
    @objc func done() {
        scoreTextField.text = score
        scoreTextField.endEditing(true)
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scoreList.count
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        score = scoreList[row]
        print(scoreList[row])
    
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int, forComponent component: Int) -> String? {
        score = scoreList[row]
        return scoreList[row]
    }
}

