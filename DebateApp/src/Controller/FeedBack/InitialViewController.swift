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
import Material


class InitialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, updateTableDelegate, UISearchResultsUpdating {

    
    
    //ナビゲーションアイテムのプラスボタン宣言
    var addBarButtonItem: UIBarButtonItem!
    var BarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController = UISearchController()
    
    var motionTitleArray = [String()]
    var searchResults:[String] = []
    var keywordString = String()
    
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
    
    let tagStringArray = ["インパクトがない", "イラストが足りない", "モデルが分からない"]
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        tableView.tableHeaderView = searchController.searchBar
        
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 15)!]
        
        //FB追加ボタン設置
        prepareFABButton()
        
        print("--viewDidLoad initialVC--")
        
        
        //let realm = try! Realm()
//        let objects = realm.objects(FeedBack.self)
        let sortedData = sortDate()
        objectCount = sortedData.count
        
        print(sortedData)
        
        for object in sortedData{
            objectArray.append(object)
        }
        
        for object in sortedData{
            motionTitleArray.append(object.MotionTitle)
        }
        motionTitleArray.remove(at: 0)
        print(motionTitleArray)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedBackCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        // 複数選択を有効にする
        tableView.allowsMultipleSelectionDuringEditing = true
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        print("date", date)
        
        //[+]ボタン追加
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped(_:)))
        //self.navigationItem.rightBarButtonItems = [addBarButtonItem]
        self.editButtonItem.title = "編集"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //filterボタン
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
        
        createDefaultTagList()
        
    }
    
    func createDefaultTagList(){
        let realm = try! Realm()
        let objects = realm.objects(TagList.self)
        if objects.count > 0{
            print(objects)
            print("return createDefaultTagList")
            return
        }
        
        var tagDictionaryArray = [Dictionary<String, String>]()
        
        for tag in tagStringArray{
             tagDictionaryArray.append(["tag": tag])
            
        }
        
        let tagListDictionary:[String:Any] = ["tags": tagDictionaryArray]
        let tagList = TagList(value: tagListDictionary)
        
        try! realm.write {
            realm.add(tagList)
        }
          
        print(realm.objects(TagList.self))
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //これがないと複数編集ができなくなる
        if searchController.isActive == false{
            return
        }
        
        self.searchResults = motionTitleArray.filter{
                // 大文字と小文字を区別せずに検索
                $0.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        keywordString = searchController.searchBar.text!.lowercased()
        self.tableView.reloadData()
        
    }
    
    func prepareFABButton() {
        let button = FABButton(image: Icon.cm.add, tintColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.green.base
        
        //view.layout(button).width(ButtonLayout.Fab.diameter).height(ButtonLayout.Fab.diameter)
        
        button.frame = CGRect(x: view.frame.size.width * 0.7, y: view.frame.size.height * 0.8, width: view.frame.size.width / 4.5, height: view.frame.size.width / 4.5)
        button.addTarget(self, action: #selector(addBarButtonTapped2), for: .touchUpInside)
        view.addSubview(button)
    }
    
    
    //追加ボタン
    @objc func addBarButtonTapped2(_ sender: FABButton) {
        print("【+】ボタンが押された!")
        
        //フィルター状態解除 (フィルター状態の時に画面遷移するとエラーになるため, それを防ぐ)
        isFilter = false
        self.navigationItem.title = ""
        //検索解除
        searchController.isActive = false
        
        let ResisterFBVC = storyboard?.instantiateViewController(withIdentifier: "Resister")  as! ResisterFBViewController
        ResisterFBVC.delegate = self

                          
        //画面遷移
        navigationController?.pushViewController(ResisterFBVC, animated: true)
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
            
        //すべてのデータを返す(フィルターじゃない時)
        else if filter == "フィルター解除"{
            isFilter = false
            return sortDate()
        }
        print("Error filterData in InitialVC")
        return objects
        
    }
    
    //検索バーで入力した文字を含むFBのみを抽出
    func searchDataBySearchBar(keyword: String)  -> Results<FeedBack>{
        let realm = try! Realm()
        var objects = realm.objects(FeedBack.self)
        
        if isFilter {
            objects = filterData(filter: stringFilter)
        }
        
        //デフォルトですべて表示
        if keyword == ""{
            return objects.sorted(byKeyPath: "date", ascending: false)
        }
        
        print(keyword)
        let searched = objects.filter("MotionTitle CONTAINS[c] '\(keyword)'").sorted(byKeyPath: "date", ascending: false)
        return searched
    }
    
    
    //追加ボタン
    @objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
        print("【+】ボタンが押された!")
          
        let ResisterFBVC = storyboard?.instantiateViewController(withIdentifier: "Resister")  as! ResisterFBViewController
        ResisterFBVC.delegate = self

                          
        //画面遷移
        navigationController?.pushViewController(ResisterFBVC, animated: true)
    }
    
    //filterボタンが押された時
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
        
        //フィルターの際にnavigationBarのタイトルを変更
        if isFilter == true{
            self.navigationItem.title = "Filterd: \(stringFilter)"
        } else {
            self.navigationItem.title = ""
        }
        
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        print("setEditing")
        if editing {
            // 編集開始
            print("編集開始")
            print("searchController.isActive", searchController.isActive)
            print(tableView.allowsMultipleSelectionDuringEditing)
            self.editButtonItem.title = "完了"
        } else {
            // 編集終了
            print("編集終了")
            self.editButtonItem.title = "編集"
            print(tableView.allowsMultipleSelectionDuringEditing)
            deleteMultiData()
            tableView.reloadData()
        }
        
        // 編集モード時のみ複数選択可能とする
        tableView.isEditing = editing
    }

    
    
    //セルの構成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedBackCell
        print("--cellForRowAt--")
        //print(objectArray[indexPath.row].MotionTitle!)
        //cell.MotionLabel.text = objectArray[indexPath.row].MotionTitle
        
        if searchController.isActive {
            let searchedData = searchDataBySearchBar(keyword: keywordString)
            print("searchedData", searchedData)
            let object = searchedData[indexPath.row]
            
            print(indexPath.row, "object.MotionTitle: ", object.MotionTitle!)
            cell.MotionLabel.text = object.MotionTitle
            cell.TimeStampLabel.text = "\(object.motionGenre!),　　\(object.style!),　　\(object.date!)"
            cell.TimeStampLabel.adjustsFontSizeToFitWidth = true
            
            return cell
        }
        
        //let realm = try! Realm()
        //let objects = realm.objects(FeedBack.self)
        let sortedData = sortDate()
        var object = sortedData[indexPath.row]
        
//        motionTitleArray.removeAll()
//        for data in sortedData {
//            motionTitleArray.append(data.MotionTitle)
//        }
        
        if isFilter == true{
            let filterdData = filterData(filter: stringFilter)
            object = filterdData[indexPath.row]
        }
            
        
        //let object = objects[indexPath.row]
        
        print(indexPath.row, "object.MotionTitle: ", object.MotionTitle!)
        cell.MotionLabel.text = object.MotionTitle
        cell.TimeStampLabel.text = "\(object.motionGenre!),　　\(object.style!),　　\(object.date!)"
        cell.TimeStampLabel.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    
    //セルがタップされたとき, EditFBViewControllerに遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //画面遷移の際に検索をやめる
        //searchController.isActive = false
        
        //編集モードの時はセルを編集する処理
        if tableView.isEditing {
            if let _ = self.tableView.indexPathsForSelectedRows {
                // 選択肢にチェックが一つでも入ってたら「削除」を表示する。
                print("didSelectRowAt 削除")
                self.editButtonItem.title = "削除"
            }
        
        //編集モードじゃない時は画面遷移
        } else {
        print("didSelectRowAt")

        //タップした時にメモの中身を渡す
        let EditFBVC = storyboard?.instantiateViewController(withIdentifier: "Edit")  as! EditFBViewController
        EditFBVC.delegate = self

        //中身とセルの順番を渡す
        print("\(String(indexPath.row)) is selected")

        EditFBVC.cellNumber = indexPath.row
        EditFBVC.isFilter = isFilter
        EditFBVC.filterString = stringFilter
        EditFBVC.isSearch = searchController.isActive
        EditFBVC.keywordString = keywordString
        
        //画面遷移の際に検索, フィルターをやめる
        searchController.isActive = false
        isFilter = false
        self.navigationItem.title = ""
        
        //画面遷移
        navigationController?.pushViewController(EditFBVC, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 編集モードじゃない場合はreturn
        guard tableView.isEditing else {
            print("return didDeselectRowAt")
            return }
        
        if let _ = self.tableView.indexPathsForSelectedRows {
            self.editButtonItem.title = "削除"
            print("didDeselectRowAt self.tableView.indexPathsForSelectedRows")
        }
        //最後の１つのチェックが解除された時
        else {
            // 何もチェックされていないときは完了を表示
            print("didDeselectRowAt else")
            self.editButtonItem.title = "完了"
        }
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
        if searchController.isActive {
            let searchedData = searchDataBySearchBar(keyword: keywordString)
            print("numberOfRowsInSection", searchedData.count)
            return searchedData.count
        } else {
           print("numberOfRowsSections: ", objectCount)
           return objectCount
        }
    }


    //横スライドでセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath)
        print("indexPath.row: \(indexPath.row) 削除")
        // 先にデータを削除しないと、エラーが発生します。
        deleteSingleData(number: indexPath.row)
        tableView.reloadData()
        //tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    //データを削除(１つ)
    func deleteSingleData(number:Int){
        print("--deleteSingleData--")
        let realm = try! Realm()
        
        //フィルター状態の時
        if isFilter == true{
            let filteredData = filterData(filter: stringFilter)
            try! realm.write {
                realm.delete(filteredData[number])
            }
            objectCount = filteredData.count
        
        //フィルターじゃない時
        } else {
            let sortedData = sortDate()
            try! realm.write {
                realm.delete(sortedData[number])
            }
            objectCount = sortedData.count
        }

        print("\(number)削除")
        print("objectCount", objectCount)
    }
    

    
    //複数のデータを削除
    func deleteMultiData(){
        //FBが１つもない時は終了
        if objectCount == 0 {
            print("objectCount", objectCount)
            return
        }
     
        let realm = try! Realm()
        
        //複数選択の時
        if let selectedIndexPaths = self.tableView.indexPathsForSelectedRows{
            let sortedIndexPaths =  selectedIndexPaths.sorted { $0.row > $1.row }
            print("複数")
            
            //フィルター状態の時
            if isFilter == true{
                let filteredData = filterData(filter: stringFilter)
                
                try! realm.write {
                    for indexPathList in sortedIndexPaths{
                        realm.delete(filteredData[indexPathList.row])
                        print(indexPathList.row)
                    }
                }
                objectCount = filteredData.count
                print(sortedIndexPaths, "削除(ソート)")
                
            //フィルターじゃない時
            } else {
                let sortedData = sortDate()
                try! realm.write {
                    for indexPathList in sortedIndexPaths{
                        realm.delete(sortedData[indexPathList.row])
                        print(indexPathList.row)
                    }
                }
                objectCount = sortedData.count
                print(sortedIndexPaths, "削除")
            }
        }
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
