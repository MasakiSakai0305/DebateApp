//
//  ViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/02.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift

protocol updateTableDelegate {
    
    func updateTable()
    
}


class ResisterFBViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate{
    
    var delegate:updateTableDelegate?
    
    //決定ボタン(TextFieldのMotionをLabelに反映)
    @IBOutlet weak var doneButton: UIButton!
    //モーションを表示するLabel
    @IBOutlet weak var motionLabel: UILabel!
    //モーションを入力するTextField
    @IBOutlet weak var motionTextField: UITextField!
    //スコアを入力するTextField
    @IBOutlet weak var scoreTextField: UITextField!
    //FBを入力するTextView
    @IBOutlet weak var FBTextView: UITextView!
    
    //ラベル各種
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var WLLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //スコア入力用のPickerView
    var pickerView: UIPickerView = UIPickerView()
   
    //ナビゲーションアイテムのボタン宣言
    var notSaveBarButtonItem: UIBarButtonItem!
    
    //セーブするかどうかを判断するフラグ
    var isSave = true
    
    var CheckedWLButtonTag = 0  //チェックされているボタンのタグ
    var CheckedStyleButtonTag = 10
    
    //それぞれ画像を読み込む
    let checkedImage = UIImage(named: "checkOn")! as UIImage
    let uncheckedImage = UIImage(named: "checkOff")! as UIImage
    
    let WLList = ["勝ち", "負け"]
    let styleList = ["NA", "BP", "Asian"]
    var scoreList = ["65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82","83", "84", "85"]
    
    //デフォルトで設定
    var WLString = "勝ち"
    var styleString = "NA"
    var score = "65"
    var motionTitleString = "No title"
    
    //日時を取得する際に使用
    let date = Date()
    let dateFormatter = DateFormatter()

    
    let center = Int(UIScreen.main.bounds.size.width / 2)
    
    var WLButtonArray = [UIButton]()
    var styleButtonArray = [UIButton]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionTextField.delegate = self
        FBTextView.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        navigationController?.delegate = self
        
        //スコア入力機能設定
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([doneItem], animated: true)
        scoreTextField.inputView = pickerView
        scoreTextField.inputAccessoryView = toolBar
        scoreTextField.text = score
        
        
        //[保存せず戻る]ボタン追加
        notSaveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(notSaveBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [notSaveBarButtonItem]

        //モーションラベル
        motionLabel.text = motionTitleString
        
        //"勝敗"ラベル設定
        WLLabel.frame = CGRect(x: center - 170, y: 200, width: 80, height: 30)
        styleLabel.frame = CGRect(x: center + 10, y: 200, width: 80, height: 30)
        
        //"スコア"ラベル設定
        scoreLabel.frame = CGRect(x: center - 170, y: 340, width: 60, height: 30)
        scoreTextField.frame = CGRect(x: center - 100, y: 340, width: 40, height: 30)
        
        //FBテキストビュー設定
        FBTextView.layer.borderColor = UIColor.black.cgColor
        FBTextView.layer.borderWidth = 1.0
        
        doneButton.tag = 100
        motionLabel.numberOfLines = 3
        
        //ラジオボタン設置(勝敗)
        for i in 0..<WLList.count {
            set_WLRadioButton(num: i)
        }
     
        
        //ラジオボタン設置(スタイル)
        for i in 0..<styleList.count {
            set_styleRadioButton(num: i)
        }
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHm", options: 0, locale: Locale(identifier: "en_JP"))
       
//
//        let fb = FeedBack()
//        let realm = try! Realm()
//
////        // DBに書き込む
////        try! realm.write {
////            realm.add(fb)
////        }
////
////        let obs = realm.objects(FeedBack.self)
////        for ob in obs{
////            print(ob.MotionTitle)
////        }
////
//        try! realm.write {
//            realm.deleteAll()
//        }

    
    }
    
    //前の画面に戻るとき,textviewの中身をメモに格納
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("\n--navigationController from ResisterFB--")
        print(viewController)
        
        //前の画面に戻るとき
        if viewController is InitialViewController {
            print("viewController is InitialViewController")
            
            //セーブするか判断
            if isSave == true{
                print("Save")
                saveData()
                delegate?.updateTable()
            } else {
                print("Not save")
                delegate?.updateTable()
            }
        
        }
    }
    
    @objc func notSaveBarButtonTapped(_ sender: UIBarButtonItem){
        print("[保存せず終了ボタン]が押された")
        
        //セーブしない
        isSave = false
        
        //画面遷移(InitialVCに戻る)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    //DBの中身削除(試し)
    @IBAction func save(_ sender: Any) {
        
//        let fb = FeedBack()
//        let realm = try! Realm()
//
//        fb.MotionTitle = motionTitleString
//        fb.FeedBackString = FBTextView.text!
//        fb.result = WLString
//        fb.score = Int(score)!
//        fb.style = styleString
//
//        // DBに書き込む
//        try! realm.write {
//            realm.add(fb)
//        }
//
//        let obs = realm.objects(FeedBack.self)
//        for ob in obs{
//            print(ob.MotionTitle!)
//            print(ob)
//        }
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        print("--All delete--\n")
        let obs = realm.objects(FeedBack.self)
        print(obs)
        
    }
    
    //DBにFBを書きこむ
    func saveData() {
        
        let fb = FeedBack()
        let realm = try! Realm()

        fb.MotionTitle = motionTitleString
        fb.FeedBackString = FBTextView.text!
        fb.result = WLString
        fb.score = Int(score)!
        fb.style = styleString
        fb.date = dateFormatter.string(from: date)

        // DBに書き込む
        try! realm.write {
            realm.add(fb)
        }

        let obs = realm.objects(FeedBack.self)
        print(obs)
        

    }
    
    
    //TextFieldの文字をLabelに反映(決定ボタン)
    @IBAction func motionDecide(_ sender: Any) {
        print("button was pushed")
        
        if motionTextField.text == ""{
            print("no content")
            motionLabel.text = "無題"
        } else {
            motionLabel.text = motionTextField.text!
        }
        
        
        motionTitleString = motionLabel.text!
        
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
        button.frame = CGRect(x: center - 170,y: y,width: 30,height: 30)
        button.tag = num
        
        //デフォルトで"勝ち"にチェックを入れる
        if num == 0{
            button.setImage(checkedImage, for: .normal)
            CheckedWLButtonTag = button.tag
        }
        
        WLButtonArray.append(button)
        
        
        let label = UILabel()
        label.text = WLList[num]
        label.frame = CGRect(x: center - 130,y: y,width: 70,height: 30)
       
        
        self.view.addSubview(button)
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
        
        
        //デフォルトで"NA"にチェックを入れる
        if num == 0{
            button.setImage(checkedImage, for: .normal)
            CheckedStyleButtonTag = button.tag
        }
        
        styleButtonArray.append(button)
        
        let label = UILabel()
        label.text = styleList[num]
        label.frame = CGRect(x: center + 60,y: y, width: 70,height: 30)
        self.view.addSubview(button)
        self.view.addSubview(label)
    }

    //押されたボタンの画像をcheck_on.pngに変える(勝敗)
    @objc func WLButttonClicked(_ sender: UIButton) {
        print("\n--WLButttonClicked--")
        print("CheckedWLButtonTag: ", CheckedWLButtonTag)
        ChangeToUncheckedWL(num: CheckedWLButtonTag)
        let button = sender
        button.setImage(checkedImage, for: .normal)
        CheckedWLButtonTag = button.tag  //check_on.pngになっているボタンのtagを更新
        WLString = WLList[CheckedWLButtonTag]
        print("checkd: ", WLString)
  
    }
    
    //押されたボタンの画像をcheck_on.pngに変える(スタイル)
    @objc func styleButttonClicked(_ sender: UIButton) {
        print("\n--styleButttonClicked--")
        ChangeToUncheckedStyle(num: CheckedStyleButtonTag)
        let button = sender
        button.setImage(checkedImage, for: .normal)
        CheckedStyleButtonTag = button.tag  //check_on.pngになっているボタンのtagを更新
        styleString = styleList[CheckedStyleButtonTag - 10]
        print("checkd: ", styleString)

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
    
    
    
    /*---入力時のキーボード関連---*/
    
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
    
    //決定ボタン(スコア入力終了)
    @objc func done() {
        scoreTextField.text = score
        scoreTextField.endEditing(true)
    }
    
    
    
    
    /*---Picker view関連---*/
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

