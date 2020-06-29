//
//  ViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/02.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift
import IQKeyboardManagerSwift
import TagListView


protocol updateTableDelegate {
    func updateTable()
}

/*
 ResisterFBVC
 内容：FBを新規作成作成する
 
 記述内容
 ・モーション
 ・スタイル
 ・スコア
 ・ロール
 ・タグ
 ・サイド
 ・日付
 ・モーションジャンル
 ・勝敗
*/


class ResisterFBViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, TagListViewDelegate, updateTagDelegate {
    
    
    
    var delegate:updateTableDelegate?
    
    //決定ボタン(TextFieldのMotionをLabelに反映)
    @IBOutlet weak var doneButton: UIButton!
    //モーションを表示するLabel
    @IBOutlet weak var motionLabel: UILabel!
    //モーションを入力するTextField
    @IBOutlet weak var motionTextField: UITextField!
    //スコアを入力するTextField
    @IBOutlet weak var scoreTextField: UITextField!
    //日付を入力するTextField
    @IBOutlet weak var dateTextField: UITextField!
    //FBを入力するTextView
    @IBOutlet weak var FBTextView: UITextView!
    //モーションジャンルを入力するTextField
    @IBOutlet weak var motionGenreTextField: UITextField!
    //サイドを入力するTextField
    @IBOutlet weak var sideTextField: UITextField!
    //ロールを入力するTextField
    @IBOutlet weak var roleTextField: UITextField!
    //タグを追加するボタン
    @IBOutlet weak var addTagButton: UIButton!
    
    //ラベル各種
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var WLLabel: UILabel!
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
    //タグ入力用
    let tagListView = TagListView()
    
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
    
    
    //デフォルトで設定
    var WLString = "勝ち"
    var styleString = "NA"
    var score = "65"
    var motionTitleString = "No title"
    var year = ""
    var month = ""
    var day = ""
    var dates = "2020年/1月/1日"
    var motionGenre = "Animal"
    var side = "Gov"
    var role = "PM"
    
    //日時を取得する際に使用
    let date = Date()
    let dateFormatter = DateFormatter()

    
    let center = Int(UIScreen.main.bounds.size.width / 2)
    
    //スクリーンのサイズ
    let screenSize = UIScreen.main.bounds.size
    //textViewを編集しているかどうかを確認
    var isTextViewEditing = Bool()
    
    
    var WLButtonArray = [UIButton]()
    var styleButtonArray = [UIButton]()
    
    //タグ自体が削除された時にその情報を渡す一時変数
    var deletedTagList = [String]()


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
        
        //スコア入力UI設定
        let toolBarScore = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneScore))
        toolBarScore.setItems([doneItem], animated: true)
        scoreTextField.inputView = pickerViewScore
        scoreTextField.inputAccessoryView = toolBarScore
        scoreTextField.text = score
        
        //日付入力UI設定
        let toolBarDate = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItemDate = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDate))
        toolBarDate.setItems([doneItemDate], animated: true)
        dateTextField.inputView = pickerViewDate
        dateTextField.inputAccessoryView = toolBarDate
        dateTextField.text = dates
        
        //モーションジャンル入力UI設定
        let toolBarMotionGenre = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItemMotionGenre = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneMotionGenre))
        toolBarMotionGenre.setItems([doneItemMotionGenre], animated: true)
        motionGenreTextField.inputView = pickerViewMotionGenre
        motionGenreTextField.inputAccessoryView = toolBarMotionGenre
        motionGenreTextField.text = motionGenre
        
        //サイド入力UI設定
        let toolBarSide = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItemSide = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSide))
        toolBarSide.setItems([doneItemSide], animated: true)
        sideTextField.inputView = pickerViewSide
        sideTextField.inputAccessoryView = toolBarSide
        sideTextField.text = side
        
        //ロール入力UI設定
        let toolBarRole = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItemRole = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneRole))
        toolBarRole.setItems([doneItemRole], animated: true)
        roleTextField.inputView = pickerViewRole
        roleTextField.inputAccessoryView = toolBarRole
        roleTextField.text = role
        
        //[保存せず戻る]ボタン追加
        notSaveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(notSaveBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [notSaveBarButtonItem]

        //モーションラベル
        motionLabel.frame = CGRect(x:view.frame.size.width/20, y: view.frame.size.height/20, width: view.frame.size.width, height: view.frame.size.height/5)
        motionLabel.text = motionTitleString
        //モーションラベルの行数を設定
        motionLabel.numberOfLines = 3
        
        //勝敗, スタイルラベル位置設定
        WLLabel.frame = CGRect(x:view.frame.size.width/17, y: view.frame.size.height/3.3, width: view.frame.size.width/5, height: view.frame.size.height/15)
        styleLabel.frame = CGRect(x: view.frame.size.width * 0.55, y: view.frame.size.height/3.2, width: view.frame.size.width/5, height: view.frame.size.height/21)
        
        //スコアUI位置設定
        scoreLabel.frame = CGRect(x: view.frame.size.width/25, y: view.frame.size.height/2, width: view.frame.size.width/6, height: view.frame.size.height/21)
        scoreTextField.frame = CGRect(x:view.frame.size.width/5.2, y: view.frame.size.height/2, width: view.frame.size.width/9, height: view.frame.size.height/21)
        
        //"日付"UI位置設定
        dateLabel.frame = CGRect(x:view.frame.size.width/25, y: view.frame.size.height/1.8, width: view.frame.size.width/6, height: view.frame.size.height/21)
        dateTextField.frame = CGRect(x:view.frame.size.width/5.5, y: view.frame.size.height/1.8, width: view.frame.size.width/3, height: view.frame.size.height/21)
        
        //FBテキストビューUI設定
        FBTextView.layer.borderColor = UIColor.black.cgColor
        FBTextView.layer.borderWidth = 1.0
        FBTextView.frame = CGRect(x: view.frame.size.width/17, y: view.frame.size.height * 0.9, width: view.frame.size.width * 0.9, height: view.frame.size.height * 0.05)
        print("view.frame.size.height", view.frame.size.height)
        print("self", self.view.frame.size.height)
        print("width", view.frame.size.width)
        
        //"ジャンル"UI位置設定
        motionGenreLabel.frame = CGRect(x:view.frame.size.width * 0.55, y: view.frame.size.height/1.8, width: view.frame.size.width/5, height: view.frame.size.height/21)
        motionGenreTextField.frame = CGRect(x:view.frame.size.width * 0.77, y: view.frame.size.height/1.8, width: view.frame.size.width/6, height: view.frame.size.height/21)
        
        //"ロール"UI位置設定
        roleLabel.frame = CGRect(x: view.frame.size.width * 0.55, y: view.frame.size.height * 0.63, width: view.frame.size.width/5, height: view.frame.size.height/21)
        roleTextField.frame = CGRect(x: view.frame.size.width * 0.72, y: view.frame.size.height * 0.63, width: view.frame.size.width/5, height: view.frame.size.height/21)
        
        //"サイド"UI位置設定
        sideLabel.frame = CGRect(x: view.frame.size.width/25, y: view.frame.size.height * 0.63, width: view.frame.size.width/5, height: view.frame.size.height/21)
        sideTextField.frame = CGRect(x: view.frame.size.width * 0.23, y: view.frame.size.height * 0.63, width: view.frame.size.width/5, height: view.frame.size.height/21)
        
        //タグを追加する関連のUI設定
        addTagButton.frame = CGRect(x: view.frame.size.width/25, y: view.frame.size.height * 0.7, width: view.frame.size.width * 0.9, height: view.frame.size.height/25)
        //addTagButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //タグUI
        tagListView.frame = CGRect(x: view.frame.size.width/25, y: view.frame.size.height * 0.75, width: view.frame.size.width * 0.9, height: 0)
        // タグの削除ボタンを有効に
        tagListView.enableRemoveButton = true
        // 今回は削除ボタン押された時の処理を行う
        tagListView.delegate = self
        // タグの見た目を設定
        tagListView.alignment = .left
        tagListView.cornerRadius = 3
        tagListView.textColor = UIColor.black
        //tagListView.borderColor = UIColor.lightGray
        tagListView.borderWidth = 1
        tagListView.paddingX = 10
        tagListView.paddingY = 5
        tagListView.textFont = UIFont.systemFont(ofSize: 16)
        tagListView.tagBackgroundColor = UIColor.white
        // タグ削除ボタンの見た目を設定
        tagListView.removeButtonIconSize = 10
        tagListView.removeIconLineColor = UIColor.black
        view.addSubview(tagListView)
        
        //addTagButton.removeFromSuperview()
        
        //「決定ボタン」のタグを設定
        doneButton.tag = 100
        
        
        //ラジオボタン設置(勝敗)
        for i in 0..<feedbackItem.WLList.count {
            set_WLRadioButton(num: i)
        }
     
        
        //ラジオボタン設置(スタイル)
        for i in 0..<feedbackItem.styleList.count {
            set_styleRadioButton(num: i)
        }
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        
        
        //キーボードが出てきた時に,keyboardWillShowを呼ぶ
//        NotificationCenter.default.addObserver(self, selector: #selector(ResisterFBViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardDidShowNotification, object: nil)
//
//        キーボードが閉じる時に,keyboardWillHideを呼ぶ
//        NotificationCenter.default.addObserver(self, selector: #selector(ResisterFBViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        //textViewが重なる時に上に来るようにする
        self.view.bringSubviewToFront(FBTextView)
       
    
    }
    
    //tagListViewのタグを削除する
    func deleteTagfromListViewTags(deleteTagList:[String]) {
        print("deleteTagfromListViewTags in editvc")
        for deleteTag in deleteTagList{
            print(deleteTag)
            tagListView.removeTag(deleteTag)
        }
        updateLayout()
        
    }
    
    //配列に格納された, 削除したタグの名前を受け取る(delegateメソッド)
    func sendDeleteTagList(deleteTagList:[String]){
        print("sendDeleteTagList", deleteTagList)
        deletedTagList = deleteTagList
    }
    
    //タグを削除する,画面が戻る段階で呼ばれる(delegateメソッド)
    func deleteTagFromTagView(deleteTagList:[String]){
        print("deleteTagFromTagView delegateメソッド")
        print(deleteTagList)
        for deleteTag in deleteTagList{
            print("deleteTag: ", deleteTag)
            tagListView.removeTag(deleteTag)
        }
        updateLayout()
    }
    
    
    //タグ選択画面に遷移
    @IBAction func GoTagList(_ sender: Any) {
        //画面遷移
        performSegue(withIdentifier: "Tag", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for segue")
        let TagListVC = segue.destination as! TagListTableViewController
        TagListVC.delegate = self
        
        
    }
    
    //タグを追加 (delegateメソッド)
    func AddTagAndUpdateLayout(TagString:String, deleteTagList:[String]) {
        print("AddTagAndUpdateLayout")
        
        //削除・タグ追加を同時に行なっている時のために呼び出す
        deleteTagfromListViewTags(deleteTagList: deleteTagList)
        
        tagListView.addTag(TagString)
        updateLayout()
    }

    // タグ削除ボタンが押された
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        // リストからタグ削除
        sender.removeTagView(tagView)
        updateLayout()
    }

    func updateLayout() {
        if tagListView.tagViews.count > 0 {
            //addTagButton.removeFromSuperview()
            print(tagListView.tagViews[0].borderWidth)
        } else {
            //view.addSubview(addTagButton)
        }
        
        
        // タグ全体の高さを取得
        tagListView.frame.size = tagListView.intrinsicContentSize
        
        print("tagListView.frame.size", tagListView.frame.size)
        if tagListView.frame.size.height >= 60{
            //tagListView.frame.size.height = 60
            print("if")
        }

    }
    
    //ResisterVCからInitialVCに戻るとき,FBの内容を保存するかどうか判定
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        //print("\n--navigationController from ResisterFB--")
        //print(viewController)
        
        //前の画面に戻るとき
        if viewController is InitialViewController {
            print("viewController is InitialViewController")
            
            //セーブするか判断
            if isSave == true{
                saveData()
                delegate?.updateTable()
            } else {
                print("Not save")
                delegate?.updateTable()
            }
        }
    }
    
    //FB内容を保存せず終了する
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
             //セーブしない(フラグを立てる)
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

    
    
    //DBの中身削除(試し)
    @IBAction func save(_ sender: Any) {
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
        print("SaveData methods(in ResisterFBViewController) was called")
                
        var tagDictionaryArray = [Dictionary<String, String>]()
        //print((tagListView.tagViews[0].titleLabel?.text!)! as String)
        for tagView in tagListView.tagViews{
//            print(tagView.titleLabel!.text!)
            tagDictionaryArray.append(["tag": tagView.titleLabel!.text!])
        }
        
        
        let fbDictionary: [String:Any] =
            ["MotionTitle":motionTitleString,
             "FeedBackString": FBTextView.text!,
             "result": WLString,
             "score": Int(score)!,
             "style": styleString,
             "date": dates,
             "motionGenre": motionGenre,
             "role":  roleTextField.text!,
             "side": sideTextField.text!,
             "tags": tagDictionaryArray
            ]
        
        let realm = try! Realm()
        let fb = FeedBack(value: fbDictionary)
        
        // DBに書き込む
        try! realm.write {
            realm.add(fb)
        }

        //デバッグ用
        let obs = realm.objects(FeedBack.self)
        print(obs)
        
    }
    
    
    //決定ボタンが押されたとき, motionTextFieldの文字をLabelに反映
    @IBAction func motionDecide(_ sender: Any) {
        print("Done button was pushed")
        
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
        label.text = feedbackItem.WLList[num]
        label.frame = CGRect(x: center - 130,y: y,width: 70,height: 30)
       
        self.view.addSubview(button)
        self.view.addSubview(label)
    }
    
    //ラジオボタン(スタイル)を配置する
    func set_styleRadioButton(num:Int){
        let button = UIButton()
        let center = Int(UIScreen.main.bounds.size.width / 2)  //中央の位置
        let y = Int(view.frame.size.height/2.8) + Int(view.frame.size.width/9) * num  //ボタン同士が重ならないようyを調整
        button.setImage(uncheckedImage, for: .normal)
        button.addTarget(self, action: #selector(styleButttonClicked(_:)), for: .touchUpInside)
        button.frame = CGRect(x: view.frame.size.width * 0.55,y: CGFloat(y), width: view.frame.size.width/12 ,height: view.frame.size.width/12)
        
//        CGRect(x: , y: , width: view.frame.size.width/5, height: view.frame.size.height/21)
        button.tag = num + 10
        
        
        //デフォルトで"NA"にチェックを入れる
        if num == 0{
            button.setImage(checkedImage, for: .normal)
            CheckedStyleButtonTag = button.tag
        }
        
        styleButtonArray.append(button)
        
        let label = UILabel()
        label.text = feedbackItem.styleList[num]
        label.frame = CGRect(x: view.frame.size.width * 0.65,y: CGFloat(y) + 5, width: view.frame.size.width/6, height: view.frame.size.width/21)
        
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
    
    //returnしたらキーボード閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //テキストフィールドを閉じる
        motionTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("フォーカスが外れた後")
    }
   

    //入力画面もしくは, keyboardの外を押したらキーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.FBTextView.isFirstResponder) {
            self.FBTextView.resignFirstResponder()
        }
        
        if (self.motionTextField.isFirstResponder) {
            self.motionTextField.resignFirstResponder()
        }
        
//        if (self.motionGenreTextField.isFirstResponder) {
//            self.motionGenreTextField.resignFirstResponder()
//        }
    }
    

    
    //決定ボタン(スコア入力終了)
    @objc func doneScore() {
        scoreTextField.text = score
        scoreTextField.endEditing(true)
    }
    
    //日付入力終了(doneItemDateのselector)
    @objc func doneDate(){
        dateTextField.text = year + "/" + month + "/" + day
        dates =  dateTextField.text!
        print(dates)
        dateTextField.endEditing(true)
    }
    
    //モーションジャンル入力終了(doneItemMotionGenreのselector)
    @objc func doneMotionGenre(){
        motionGenreTextField.text  = motionGenre
        motionGenreTextField.endEditing(true)
    }
    
    //サイド入力終了(doneItemSideのselector)
    @objc func doneSide(){
        sideTextField.text  = side
        sideTextField.endEditing(true)
    }
    
    //ロール入力終了(doneItemRoleのselector)
    @objc func doneRole(){
        roleTextField.text  = role
        roleTextField.endEditing(true)
    }
    
    
    /*---Picker view関連---*/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch pickerView {
        //スコアpicker
        case pickerViewScore:
            //print("pickerView")
            return 1
        //日付picker
        case pickerViewDate:
            //print("pickerViewDate")
            return 3
        //モーションジャンルpicker
        case pickerViewMotionGenre:
            //print("pickerViewMotionGenre")
            return 1
        //サイドpicker
        case pickerViewSide:
            //print("pickerViewSide")
            return 1
        //ロールpicker
        case pickerViewRole:
            //print("pickerViewRole")
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
        
        //pickerViewで選択された値を変数に格納
        switch pickerView {
        
        //スコア
        case pickerViewScore:
            score = feedbackItem.scoreList[row]
            print(feedbackItem.scoreList[row])
        //日付
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
        //モーションジャンル
        case pickerViewMotionGenre:
            motionGenre = feedbackItem.motionGenreList[row]
            print(feedbackItem.motionGenreList[row])
        //サイド
        case pickerViewSide:
            side = feedbackItem.sideList[row]
        //ロール
        case pickerViewRole:
            role = feedbackItem.roleList[row]
            
        default:
            print("Error in numberOfComponents ResisterVC")
        }
    
    }
    
    // UIPickerViewの最初の表示を設定
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

