//
//  EditFBViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/11.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift

class EditFBViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {


    var delegate:updateTableDelegate?

    //各種UI
    @IBOutlet weak var motionTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var FBTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var motionGenreTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var sideTextField: UITextField!
    
    //各種ラベル
    @IBOutlet weak var motionLabel: UILabel!
    @IBOutlet weak var WLLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var motionGenreLabel: UILabel!
    @IBOutlet weak var sideLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    //スコア入力用のPickerView
    var pickerViewScore: UIPickerView = UIPickerView()
    //日付入力用のPickerView
    var pickerViewDate: UIPickerView = UIPickerView()
    //モーションジャンル入力用のPickerView
    var pickerViewMotionGenre: UIPickerView = UIPickerView()
    //サイド入力用のPickerView
    var pickerViewSide: UIPickerView = UIPickerView()
    //ロール入力用のPickerView
    var pickerViewRole: UIPickerView = UIPickerView()
    
    //ナビゲーションアイテムのボタン宣言
    var notSaveBarButtonItem: UIBarButtonItem!
    
    //アラート(保存せず終了する際に使用)
    var alertController: UIAlertController!
   
    //セーブするかどうかを判断するフラグ
    var isSave = true
   
    var CheckedWLButtonTag = 0  //チェックされているボタンのタグ
    var CheckedStyleButtonTag = 10
   
    //それぞれ画像を読み込む
    let checkedImage = UIImage(named: "checkOn")! as UIImage
    let uncheckedImage = UIImage(named: "checkOff")! as UIImage
   
    
    let feedbackItem = FeedBackItemList()
    
    //デフォルト
    var WLString = "勝ち"
    var styleString = "NA"
    var score = "65"
    //var motionTitleString = "No title"
    var FBString:String!
    var year = ""
    var month = ""
    var day = ""
    var dates = "2020/01/01"
    var motionGenre = ""
    var side = "Gov"
    var role = "PM"
    

    //日時を取得する際に使用
    let date = Date()
    let dateFormatter = DateFormatter()

   
    let center = Int(UIScreen.main.bounds.size.width / 2)
    
    //スクリーンのサイズ
    let screenSize = UIScreen.main.bounds.size
    //textViewのyを記憶するための変数
    var textViewHeight = CGFloat()
    //textViewを編集しているかどうかを確認
    var isTextViewEditing = Bool()
    
   
    var WLButtonArray = [UIButton]()
    var styleButtonArray = [UIButton]()
    
    //何番めのデータを参照・更新するか
    var cellNumber:Int!
    
    //フィルター or 検索をしている場合
    var isFilter = Bool()
    var isSearch = Bool()
    var filterString = String()
    var keywordString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        motionTextField.delegate = self
        FBTextView.delegate = self
        motionGenreTextField.delegate = self
        pickerViewScore.delegate = self
        pickerViewScore.dataSource = self
        pickerViewDate.delegate = self
        pickerViewDate.dataSource = self
        pickerViewMotionGenre.delegate = self
        pickerViewMotionGenre.dataSource = self
        pickerViewSide.delegate = self
        pickerViewSide.dataSource = self
        pickerViewRole.delegate = self
        pickerViewRole.dataSource = self
        navigationController?.delegate = self
        
        
        
        var objects = sortDate()
        if isFilter {
            objects = filterData(filter: "\(filterString)")
        }
        
        if isSearch {
            objects = searchDataBySearchBar(keyword: keywordString)
        }
        
        
        print("cellNumber", cellNumber)
        //DBを読み込んで値をUIに書き込む
        let object = objects[cellNumber]
        motionLabel.text = object.MotionTitle
        motionTextField.text = object.MotionTitle
        scoreTextField.text = String(object.score)
        FBTextView.text = object.FeedBackString
        WLString = object.result
        styleString = object.style
        dateTextField.text = object.date
        motionGenreTextField.text = object.motionGenre
        sideTextField.text = object.side
        roleTextField.text = object.role
       
       //スコア入力機能設定
       let toolBarScore = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
       let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneScore))
       toolBarScore.setItems([doneItem], animated: true)
       scoreTextField.inputView = pickerViewScore
       scoreTextField.inputAccessoryView = toolBarScore
       
       //日付入力機能
       let toolBarDate = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
       let doneItemDate = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDate))
       toolBarDate.setItems([doneItemDate], animated: true)
       dateTextField.inputView = pickerViewDate
       dateTextField.inputAccessoryView = toolBarDate
        
        //モーションジャンル入力機能設定
        let toolBarMotionGenre = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItemMotionGenre = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneMotionGenre))
        toolBarMotionGenre.setItems([doneItemMotionGenre], animated: true)
        motionGenreTextField.inputView = pickerViewMotionGenre
        motionGenreTextField.inputAccessoryView = toolBarMotionGenre
        
        //サイド入力機能
        let toolBarSide = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItemSide = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSide))
        toolBarSide.setItems([doneItemSide], animated: true)
        sideTextField.inputView = pickerViewSide
        sideTextField.inputAccessoryView = toolBarSide
        
        
        //ロール入力機能
        let toolBarRole = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItemRole = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneRole))
        toolBarRole.setItems([doneItemRole], animated: true)
        roleTextField.inputView = pickerViewRole
        roleTextField.inputAccessoryView = toolBarRole
    
        
       //[保存せず戻る]ボタン追加
       notSaveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(notSaveBarButtonTapped(_:)))
       self.navigationItem.rightBarButtonItems = [notSaveBarButtonItem]
       
       //"勝敗", "スタイル"ラベル設定
       WLLabel.frame = CGRect(x:view.frame.size.width/17, y: view.frame.size.height/3.3, width: view.frame.size.width/5, height: view.frame.size.height/15)
       styleLabel.frame = CGRect(x: view.frame.size.width * 0.55, y: view.frame.size.height/3.2, width: view.frame.size.width/5, height: view.frame.size.height/21)
       
       //"スコア"UI位置設定
       scoreLabel.frame = CGRect(x: view.frame.size.width/25, y: view.frame.size.height/2, width: view.frame.size.width/6, height: view.frame.size.height/21)
       scoreTextField.frame = CGRect(x:view.frame.size.width/5.2, y: view.frame.size.height/2, width: view.frame.size.width/9, height: view.frame.size.height/21)
        
        //"日付"UI位置設定
        dateLabel.frame = CGRect(x:view.frame.size.width/25, y: view.frame.size.height/1.8, width: view.frame.size.width/6, height: view.frame.size.height/21)
        dateTextField.frame = CGRect(x:view.frame.size.width/5.5, y: view.frame.size.height/1.8, width: view.frame.size.width/3, height: view.frame.size.height/21)
        
    
        //"ジャンル"設定
        motionGenreLabel.frame = CGRect(x:view.frame.size.width * 0.55, y: view.frame.size.height/1.8, width: view.frame.size.width/5, height: view.frame.size.height/21)
        motionGenreTextField.frame = CGRect(x:view.frame.size.width * 0.77, y: view.frame.size.height/1.8, width: view.frame.size.width/6, height: view.frame.size.height/21)
       
        //FBテキストビュー設定
        FBTextView.layer.borderColor = UIColor.black.cgColor
        FBTextView.layer.borderWidth = 1.0
        FBTextView.frame = CGRect(x: view.frame.size.width/17, y: view.frame.size.height * 0.7, width: view.frame.size.width * 0.9, height: view.frame.size.height * 0.2)
        
        //"ロール"UI位置設定
        roleLabel.frame = CGRect(x: view.frame.size.width * 0.55, y: view.frame.size.height * 0.63, width: view.frame.size.width/5, height: view.frame.size.height/21)
        roleTextField.frame = CGRect(x: view.frame.size.width * 0.72, y: view.frame.size.height * 0.63, width: view.frame.size.width/5, height: view.frame.size.height/21)
        
        //"サイド"UI位置設定
        sideLabel.frame = CGRect(x: view.frame.size.width/25, y: view.frame.size.height * 0.63, width: view.frame.size.width/5, height: view.frame.size.height/21)
        sideTextField.frame = CGRect(x: view.frame.size.width * 0.23, y: view.frame.size.height * 0.63, width: view.frame.size.width/5, height: view.frame.size.height/21)
       
        doneButton.tag = 100
        motionLabel.numberOfLines = 3
        
        
       
        //ラジオボタン設置(勝敗)
        //DBを読み込んで勝敗をチェック
        switch WLString {
            case "勝ち":
                set_WLRadioButton(num: 0, isCheck:true)
                set_WLRadioButton(num: 1, isCheck:false)
            case "負け":
                set_WLRadioButton(num: 0, isCheck:false)
                set_WLRadioButton(num: 1, isCheck:true)
            default:
                print("Error in set_WLRadioButton")
       
       }
    
       
        //ラジオボタン設置(スタイル)
        //InitialVCから受け取った値を参照してスタイルをチェック
        switch styleString {
            case "NA":
                set_styleRadioButton(num: 0, isCheck:true)
                set_styleRadioButton(num: 1, isCheck:false)
                set_styleRadioButton(num: 2, isCheck:false)
            case "BP":
                set_styleRadioButton(num: 0, isCheck:false)
                set_styleRadioButton(num: 1, isCheck:true)
                set_styleRadioButton(num: 2, isCheck:false)

            case "Asian":
                set_styleRadioButton(num: 0, isCheck:false)
                set_styleRadioButton(num: 1, isCheck:false)
                set_styleRadioButton(num: 2, isCheck:true)

            default:
                print("Error in set_styleRadioButton")
        }
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        
//         //キーボードが出てきた時に,keyboardWillShowを呼ぶ
//         NotificationCenter.default.addObserver(self, selector: #selector(ResisterFBViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardDidShowNotification, object: nil)
//
//         //キーボードが閉じる時に,keyboardWillHideを呼ぶ
//         NotificationCenter.default.addObserver(self, selector: #selector(ResisterFBViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        //yの位置を記憶
         textViewHeight = FBTextView.frame.origin.y
         //textViewが重なる時に上に来るようにする
         self.view.bringSubviewToFront(FBTextView)

    }

    
    //前の画面に戻るとき,textviewの中身をメモに格納
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("\n--navigationController from EditFB--")
        print(viewController)
        
        //前の画面に戻るとき
        if viewController is InitialViewController {
            print("viewController is InitialViewController")
            
            //セーブするか判断
            if isSave == true{
                print("Save")
                updateData()
                delegate?.updateTable()
            } else {
                print("Not save")
                delegate?.updateTable()
            }
        
        }
    }
    
    
    @objc func notSaveBarButtonTapped(_ sender: UIBarButtonItem){
        print("[保存せず終了ボタン]が押された")
        alert(title: "", message: "フィードバックを保存せず終了しますか？")
    }
    
    //アラート(保存せず終了するボタン)
    func alert(title:String, message:String) {
         alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default, handler:{
             (action: UIAlertAction!) in
             //OKが押された時の処理
             print("OK was pushed\n")
             //セーブしない
             self.isSave = false
             //画面遷移(InitialVCに戻る)
             self.navigationController?.popViewController(animated: true)
         })
         let ngAction = UIAlertAction(title: "NG", style: .destructive, handler: {
             (action: UIAlertAction!) in
             //NGが押された時の処理
             print("NG was pushed\n")
         })
         
         alertController.addAction(okAction)
         alertController.addAction(ngAction)
         
         present(alertController, animated: true)
    }
    
    
    @IBAction func motionDecide(_ sender: Any) {
        print("決定 button was pushed")
        
        if motionTextField.text == ""{
            print("no content")
            motionLabel.text = "No title"
        } else {
            motionLabel.text = motionTextField.text!
        }
        
        //キーボード閉じる
        motionTextField.resignFirstResponder()
    }
    
    
    //DBに書きこむ(FBを更新)
    func updateData() {
        
        let realm = try! Realm()
        let sortedData = sortDate()
        var object = sortedData[cellNumber]
        
        if isFilter {
            object = filterData(filter: "\(filterString)")[cellNumber]
            print("filterData", filterData)
        }
        
        if isSearch {
            object = searchDataBySearchBar(keyword: keywordString)[cellNumber]
        }
        
        print("updateData", object)
        
        //データ更新
        try! realm.write({
            object.MotionTitle = motionLabel.text
            object.FeedBackString = FBTextView.text!
            object.result = WLString
            object.score = Int(scoreTextField.text!)!
            object.style = styleString
            object.date = dateTextField.text
            object.motionGenre = motionGenreTextField.text!
            object.side = sideTextField.text!
            object.role = roleTextField.text!
        })

        let obs = realm.objects(FeedBack.self)
        print(obs)
    }

    //データを日付でソートする
    func sortDate() -> Results<FeedBack>{
        let realm = try! Realm()
        let objects = realm.objects(FeedBack.self)
        let sorted = objects.sorted(byKeyPath: "date", ascending: false)
        return sorted
    }
    
    func filterData(filter:String) -> Results<FeedBack>{
        let realm = try! Realm()
        let objects = realm.objects(FeedBack.self)
    
        if filter == "勝ち" || filter == "負け"{
            let filtered = objects.filter("result == '\(filter)'").sorted(byKeyPath: "date", ascending: false)
            return filtered
        }
        else if filter == "NA" || filter == "BP" || filter == "Asian"{
            let filtered = objects.filter("style == '\(filter)'").sorted(byKeyPath: "date", ascending: false)
            return filtered
        }
            
        //すべてのデータを返す(フィルターじゃない時)
        else if filter == "フィルター解除"{
//            isFilter = false
            return sortDate()
        }
        print("Error filterData in InitialVC")
        return objects
        
    }
    
    //検索バーで入力した文字を含むFBのみを抽出
    func searchDataBySearchBar(keyword: String) -> Results<FeedBack>{
        let realm = try! Realm()
        var objects = realm.objects(FeedBack.self)
        
        if isFilter {
            objects = filterData(filter: filterString)
        }

        //デフォルトですべて表示
        if keyword == ""{
            return objects.sorted(byKeyPath: "date", ascending: false)
        }
        
        print(keyword)
        let searched = objects.filter("MotionTitle CONTAINS[c] '\(keyword)'").sorted(byKeyPath: "date", ascending: false)
        return searched
    }
    
    //ラジオボタン(勝敗)を配置する
    func set_WLRadioButton(num:Int, isCheck:Bool){
      let button = UIButton()
      //中央の位置
      let y = 240+45*num  //ボタン同士が重ならないようyを調整
      button.setImage(uncheckedImage, for: .normal)
      button.addTarget(self, action: #selector(WLButttonClicked(_:)), for: .touchUpInside)
      button.frame = CGRect(x: center - 170,y: y,width: 30,height: 30)
      button.tag = num
      
    
        //元のデータを反映してチェックする
        if isCheck {
            button.setImage(checkedImage, for: .normal)
            CheckedWLButtonTag = button.tag
            print("CheckedWLButtonTag", CheckedWLButtonTag)
        }
      
      WLButtonArray.append(button)
      

      let label = UILabel()
        print(num)
        label.text = feedbackItem.WLList[num]
      label.frame = CGRect(x: center - 130,y: y,width: 70,height: 30)
     
      
      self.view.addSubview(button)
      self.view.addSubview(label)
  }
  
    //ラジオボタン(スタイル)を配置する
    func set_styleRadioButton(num:Int, isCheck:Bool){
        let button = UIButton()
        let center = Int(UIScreen.main.bounds.size.width / 2)  //中央の位置
        let y = Int(view.frame.size.height/2.8) + Int(view.frame.size.width/9) * num  //ボタン同士が重ならないようyを調整
        button.setImage(uncheckedImage, for: .normal)
        button.addTarget(self, action: #selector(styleButttonClicked(_:)), for: .touchUpInside)
        button.frame = CGRect(x: view.frame.size.width * 0.65,y: CGFloat(y), width: view.frame.size.width/12 ,height: view.frame.size.width/12)
        button.tag = num + 10
      
        
        //元のデータを反映してチェックする
        if isCheck == true{
            button.setImage(checkedImage, for: .normal)
            CheckedStyleButtonTag = button.tag
        }

        styleButtonArray.append(button)
      
        let label = UILabel()
        label.text = feedbackItem.styleList[num]
        label.frame = CGRect(x: view.frame.size.width * 0.8,y: CGFloat(y) + 5, width: view.frame.size.width/6, height: view.frame.size.width/21)
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
      WLString = feedbackItem.WLList[CheckedWLButtonTag]
      print("checkd: ", WLString)

  }
  
  //押されたボタンの画像をcheck_on.pngに変える(スタイル)
  @objc func styleButttonClicked(_ sender: UIButton) {
      print("\n--styleButttonClicked--")
      ChangeToUncheckedStyle(num: CheckedStyleButtonTag)
      let button = sender
      button.setImage(checkedImage, for: .normal)
      CheckedStyleButtonTag = button.tag  //check_on.pngになっているボタンのtagを更新
      styleString = feedbackItem.styleList[CheckedStyleButtonTag - 10]
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
    
    //textFieldがタップされた
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isTextViewEditing = false
    }
    //textViewがタップされた
    func textViewDidBeginEditing(_ textView: UITextView) {
        isTextViewEditing = true
    }
    
    //キーボードに隠れないように, textViewの位置を上げる
    @objc func keyboardWillShow(_ notification: NSNotification){
        //textViewを編集している時のみ
        if isTextViewEditing == true {
            //キーボードの高さを取得
            let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
            
            //キーボードが上がってくる時
            //メッセージフィールドが現れる位置(y軸) = スクリーンの高さ - キーボードの高さ - メッセージの高さ
            FBTextView.frame.origin.y = screenSize.height - keyboardHeight - FBTextView.frame.height
        }
    }
    
    //キーボードが下がるので, 同時にtextViewの位置も下げる
    @objc func keyboardWillHide(_ notification:NSNotification){
        //textViewを編集している時のみ
        if isTextViewEditing == true {
            //キーボードを閉じる時
            //メッセージフィールドが現れる位置(y軸) = スクリーンの高さ -　メッセージの高さ
            FBTextView.frame.origin.y = textViewHeight

            guard let rect = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
                
            //キーボードを閉じる時間を計測
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            
            UIView.animate(withDuration: duration) {
                
                //位置を戻すアニメーション
                let transform = CGAffineTransform(translationX: 0, y: 0)
                self.view.transform = transform
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
  
  //決定ボタン(スコア入力終了)
  @objc func doneScore() {
      scoreTextField.text = score
      scoreTextField.endEditing(true)
  }
  
  //決定ボタン(日付入力終了)
  @objc func doneDate(){
      dateTextField.text = year + "/" + month + "/" + day
      dates =  dateTextField.text!
      print(dates)
      dateTextField.endEditing(true)
  }
  
    //決定ボタン(モーションジャンル入力終了)
    @objc func doneMotionGenre(){
        motionGenreTextField.text  = motionGenre
        motionGenreTextField.endEditing(true)
    }
    
    //決定ボタン(サイド入力終了)
    @objc func doneSide(){
        sideTextField.text  = side
        sideTextField.endEditing(true)
    }
    
    //決定ボタン(ロール入力終了)
    @objc func doneRole(){
        roleTextField.text  = role
        roleTextField.endEditing(true)
    }

  
  
  /*---Picker view関連---*/
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
      switch pickerView {
      //スコアpicker
      case pickerViewScore:
          print("pickerView")
          return 1
      //日付picker
      case pickerViewDate:
          print("pickerViewDate")
          return 3
      //モーションジャンルpicker
      case pickerViewMotionGenre:
          print("pickerViewMotionGenre")
          return 1
      //サイドpicker
      case pickerViewSide:
        print("pickerViewSide")
        return 1
      //ロールpicker
       case pickerViewRole:
        print("pickerViewRole")
        return 1
      default:
          print("Error in numberOfComponents ResisterVC")
          return 1
      }
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      switch pickerView {
      //スコアpicker
      case pickerViewScore:
          return feedbackItem.scoreList.count
      //日付picker
      case pickerViewDate:
          switch component {
          case 0:
              return feedbackItem.yearList.count
          case 1:
              return feedbackItem.monthList.count
          case 2:
              return feedbackItem.dayList.count
          default:
              print("Error pickerViewDate component numberOfRowsInComponent ResisterVC")
              return 0
          }
      //モーションジャンルpicker
      case pickerViewMotionGenre:
        return feedbackItem.motionGenreList.count
      //サイドpicker
      case pickerViewSide:
          return feedbackItem.sideList.count
      //ロールpicker
      case pickerViewRole:
          return feedbackItem.roleList.count
        
      default:
          print("Error pickerViewSwitch numberOfComponents numberOfRowsInComponent ResisterVC")
          return 1
      }
  }
  
  // UIPickerViewのRowが選択された時の挙動
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      switch pickerView {
      
      //スコアpicker
      case pickerViewScore:
          score = feedbackItem.scoreList[row]
          print(feedbackItem.scoreList[row])
      //日付picker
      case pickerViewDate:
          switch component {
          case 0:
              year = feedbackItem.yearList[row]
              print(feedbackItem.yearList[row])
          case 1:
              month = feedbackItem.monthList[row]
              print(feedbackItem.monthList[row])
          case 2:
              day = feedbackItem.dayList[row]
              print(feedbackItem.dayList[row])
          default:
              print("Error pickerViewDate component didSelectRow ResisterVC")
          }
    //モーションジャンルpicker
    case pickerViewMotionGenre:
        motionGenre = feedbackItem.motionGenreList[row]
        print(feedbackItem.motionGenreList[row])
    //サイドpicker
    case pickerViewSide:
        side = feedbackItem.sideList[row]
    //ロールpicker
    case pickerViewRole:
        role = feedbackItem.roleList[row]
          
      default:
          print("Error in numberOfComponents ResisterVC")
      }
  
  }
  
  // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        //スコアpicker
        case pickerViewScore:
            score = feedbackItem.scoreList[row]
            return feedbackItem.scoreList[row]
          
        //日付picker
        case pickerViewDate:
            switch component {
            case 0:
                year = feedbackItem.yearList[row]
                return feedbackItem.yearList[row]
            case 1:
                month = feedbackItem.monthList[row]
                return feedbackItem.monthList[row]
            case 2:
              day = feedbackItem.dayList[row]
              return feedbackItem.dayList[row]
            default:
              print("Error pickerViewDate component numberOfRowsInComponent ResisterVC")
              return ""
            }
        //モーションジャンルpicker
        case pickerViewMotionGenre:
            return feedbackItem.motionGenreList[row]
        //サイドpicker
        case pickerViewSide:
            return feedbackItem.sideList[row]
        //ロールpicker
        case pickerViewRole:
            return feedbackItem.roleList[row]
        default:
            print("Error pickerViewSwitch numberOfComponents numberOfRowsInComponent ResisterVC")
            return ""
        }
    }

    
}
