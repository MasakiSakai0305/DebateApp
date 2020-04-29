//
//  InitialViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/06.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift
import SideMenu


class InitialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, updateTableDelegate {
    
    //ナビゲーションアイテムのプラスボタン宣言
    var addBarButtonItem: UIBarButtonItem!
    var BarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    //DBに登録してるデータ数
    var objectCount = 0
    let realm2 = try! Realm()
    //オブジェクトを格納する配列
    var objectArray = [FeedBack]()
    
    let date = Date()
    let dateFormatter = DateFormatter()
    
    //フィルター機能を使うかどうかのフラグ(cellForRowAtで使用する)
    var isFilter = Bool()
    //フィルターの種類
    var stringFilter = String()

    
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
        BarButtonItem = UIBarButtonItem(title: "filter", style: .plain, target: self, action: #selector(BarButtonTapped(_:)))
        self.navigationItem.leftBarButtonItems = [BarButtonItem]
        //self.navigationController?.navigationBar

        
//        print("日時ソート")
//        var array = ["2020年4月18日 13:50", "200年4月18日 13:50", "2020年8月18日 13:50"]
//        let soreted = array.sorted()
//        print(soreted)
        
        // サイドバーメニューからの通知を受け取る
        NotificationCenter.default.addObserver(self,selector: #selector(catchSelectMenuNotification(notification:)),
            name: Notification.Name("SelectMenuNotification"), object: nil)
        
    }
    
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
        //すべてのデータをreturnする
        else if filter == "フィルター解除"{
            isFilter = false
            return sortDate()
        }
        print("Error filterData in InitialVC")
        return objects
        
    }
    
    
    //追加ボタン
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        print("【+】ボタンが押された!")
          
        let ResisterFBVC = storyboard?.instantiateViewController(withIdentifier: "Resister")  as! ResisterFBViewController
        ResisterFBVC.delegate = self

                          
        //画面遷移
        navigationController?.pushViewController(ResisterFBVC, animated: true)
    }
    
    @objc func BarButtonTapped(_ sender: UIBarButtonItem) {
        // Define the menu
        let menu = SideMenuNavigationController(rootViewController: SideMenuViewController())
        SideMenuManager.default.leftMenuNavigationController = menu
        //let menu = SideMenuManager.default.leftMenuNavigationController!
        // SideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
        menu.settings = makeSettings()
        SideMenuPresentationStyle().menuStartAlpha = 1
        menu.statusBarEndAlpha = 10.0
        SideMenuPresentationStyle().backgroundColor = .black
        
    
        present(menu, animated: true, completion: nil)
    }
    
    // 選択されたサイドバーのアイテムを取得
    @objc func catchSelectMenuNotification(notification: Notification) -> Void {
        // メニューからの返り値を取得
        let item = notification.userInfo // 返り値が格納されている変数
        
        // 実行したい処理を記述する
        print(item!)
        print(item!["itemNo"]!)
        isFilter = true
        stringFilter = item!["itemNo"]! as! String
        let filterdData = filterData(filter: stringFilter)
        objectCount = filterdData.count
        tableView.reloadData()
    }
    
    func makeSettings() -> SideMenuSettings{
        let presentationStyle: SideMenuPresentationStyle = .menuSlideIn
        presentationStyle.onTopShadowOpacity = 1.0
        presentationStyle.menuStartAlpha = 1
        presentationStyle.presentingEndAlpha = 1
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.statusBarEndAlpha = 10.0
        //settings.statusBarEndAlpha = 0
        return settings
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
        var object = sortedData[indexPath.row]
        
        if isFilter == true{
            let filterdData = filterData(filter: stringFilter)
            object = filterdData[indexPath.row]
        }
            
        
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
    
    //セクションの数を決める
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/9
    }
    
    //セルの数
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
