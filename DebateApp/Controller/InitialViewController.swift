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
        let objects = realm.objects(FeedBack.self)
        objectCount = objects.count
        
        print(objects)
        
        for object in objects{
            objectArray.append(object)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedBackCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHm", options: 0, locale: Locale(identifier: "en_JP"))
        
        //[+]ボタン追加
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        self.navigationItem.rightBarButtonItems = [addBarButtonItem]

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    //追加ボタン
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        print("【+】ボタンが押された!")
          
        let ResisterFBVC = storyboard?.instantiateViewController(withIdentifier: "Resister")  as! ResisterFBViewController
        ResisterFBVC.delegate = self

                          
        //画面遷移
        navigationController?.pushViewController(ResisterFBVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedBackCell
        print("--cellForRowAt--")
        //print(objectArray[indexPath.row].MotionTitle!)
        //cell.MotionLabel.text = objectArray[indexPath.row].MotionTitle
        cell.MotionLabel.text = "a"
        cell.TimeStampLabel.text = "Created at: " + dateFormatter.string(from: date)
        cell.TimeStampLabel.adjustsFontSizeToFitWidth = true
        
        
        
        return cell
    }
    
    //セルの数を決める
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSections: ", objectCount)
        return objectCount
    }
    
    //高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    //保存したデータをテーブルに反映
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
