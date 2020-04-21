//
//  InitialViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/06.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift



class InitialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, updateTableDelegate {
    
    //ナビゲーションアイテムのプラスボタン宣言
    var addBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    //DBに登録してるデータ数
    var objectCount = 0
    let realm2 = try! Realm()
    //オブジェクトを格納する配列
    var objectArray = [FeedBack]()
    
    let date = Date()
    let dateFormatter = DateFormatter()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--viewDidLoad--")
        
        
        let realm = try! Realm()
//        let objects = realm.objects(FeedBack.self)
        let sortedData = sortDate()
        objectCount = sortedData.count
        
        print(sortedData)
        
        for object in sortedData{
            objectArray.append(object)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedBackCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        print("date", date)
        
        //[+]ボタン追加
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]

        
//        print("日時ソート")
//        var array = ["2020年4月18日 13:50", "200年4月18日 13:50", "2020年8月18日 13:50"]
//        let soreted = array.sorted()
//        print(soreted)
        
    }
    
    func sortDate() -> Results<FeedBack>{
        let realm = try! Realm()
        let objects = realm.objects(FeedBack.self)
        let sorted = objects.sorted(byKeyPath: "date", ascending: false)
        return sorted
    }
    
    
    //追加ボタン
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        print("【+】ボタンが押された!")
          
        let ResisterFBVC = storyboard?.instantiateViewController(withIdentifier: "Resister")  as! ResisterFBViewController
        ResisterFBVC.delegate = self

                          
        //画面遷移
        navigationController?.pushViewController(ResisterFBVC, animated: true)
    }
    
    
    //セルの構成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedBackCell
        print("--cellForRowAt--")
        //print(objectArray[indexPath.row].MotionTitle!)
        //cell.MotionLabel.text = objectArray[indexPath.row].MotionTitle
        
        //let realm = try! Realm()
        //let objects = realm.objects(FeedBack.self)
        
        let sortedData = sortDate()
        let object = sortedData[indexPath.row]
        
        //let object = objects[indexPath.row]
        
        print(indexPath.row, "object.MotionTitle: ", object.MotionTitle!)
        cell.MotionLabel.text = object.MotionTitle
        cell.TimeStampLabel.text = "Created at: " + object.date
        cell.TimeStampLabel.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    //セルがタップされたとき, EditFBViewControllerに遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        //タップした時にメモの中身を渡す
        let EditFBVC = storyboard?.instantiateViewController(withIdentifier: "Edit")  as! EditFBViewController

        EditFBVC.delegate = self

        //中身とセルの順番を渡す
        print("\(String(indexPath.row)) is selected")

        EditFBVC.cellNumber = indexPath.row
        
        //画面遷移
        navigationController?.pushViewController(EditFBVC, animated: true)
    }
    
    //セルの数を決める
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsSections: ", objectCount)
        return objectCount
    }


    //横スライドでセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("indexPath.row: \(indexPath.row) 削除")
        // 先にデータを削除しないと、エラーが発生します。
        deleteData(number: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //データを削除(１つ)
    func deleteData(number:Int){
        print("--deleteData--")
        let realm = try! Realm()
//        let objects = realm.objects(FeedBack.self)
        let sortedData = sortDate()
            
        try! realm.write {
            realm.delete(sortedData[number])
        }
        objectCount = sortedData.count
        print("\(number)削除")
        print(sortedData)

    }
    
    //保存したデータをテーブルに反映(デリゲートメソッド)
    func updateTable() {
        print("updateTable protocol was called")
        
        //objectCount更新
        let realm = try! Realm()
        let objects = realm.objects(FeedBack.self)
        
        objectCount = objects.count
        
        //リロード
        tableView.reloadData()
        
    }
    


}
