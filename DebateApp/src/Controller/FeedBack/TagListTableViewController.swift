//
//  ExTagListTableViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/08.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift
import Material

protocol updateTagDelegate {
    func AddTagAndUpdateLayout(TagString:String, deleteTagList:[String])
    func sendDeleteTagList(deleteTagList:[String])
    func deleteTagFromTagView(deleteTagList:[String])
}

class TagListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate ,TagCellDelegate, EditTagDelegate {

    

    

    @IBOutlet weak var bar: UINavigationBar!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var cellNumber = Int()
    
    var TagArray = [String]()
    var delegate:updateTagDelegate?
    
    var isAddNewTag = false
    
    //削除するタグを一時的に格納
    var deletedList = [String]()


    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //タグ追加ボタン設置
        prepareFABButton()
        
        
        tableView.register(UINib(nibName: "TagCell", bundle: nil), forCellReuseIdentifier: "tag")
        
        bar.frame = CGRect(x: 0, y: view.frame.size.height/30, width: view.frame.size.width, height: view.frame.size.height/15)
        bar.isTranslucent = false
        tableView.frame = CGRect(x: 0, y: view.frame.size.height/30 + bar.frame.size.height, width: view.frame.size.width, height: view.frame.size.height)
        
        let realm = try! Realm()
        let objects = realm.objects(TagList.self)
        
        
        //cellForRowAtで毎回Realmを使ってcellに代入するのは重くなりそうなのであらかじめ配列に格納
        for tag in objects[0].tags{
            TagArray.append(tag["tag"] as! String)
        }
        
        //deletedList.append("インパクトがない")
        //deleteTagFromDB()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tagCell = tableView.dequeueReusableCell(withIdentifier: "tag", for: indexPath) as! TagCell
        
        tagCell.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height/15)
        tagCell.tagLabel.frame = CGRect(x: tagCell.frame.size.width/20, y: tagCell.frame.size.height/5, width: tagCell.frame.size.width*0.75, height: tagCell.frame.size.height)
        tagCell.editButton.frame = CGRect(x: tagCell.frame.size.width*0.8, y: 0, width: tagCell.frame.size.width*0.2, height: tagCell.frame.size.height)
        
        tagCell.editButton.tag = indexPath.row
        
        tagCell.delegate = self
        tagCell.tagLabel?.text = TagArray[indexPath.row]
        
        return tagCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/15
    }

        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.AddTagAndUpdateLayout(TagString: TagArray[indexPath.row], deleteTagList: deletedList)
        delegate?.sendDeleteTagList(deleteTagList: deletedList)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //横スライドでセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath)
        print("indexPath.row: \(indexPath.row) 削除")
        // 先にデータを削除しないと、エラーが発生します。
        deleteTag(cellNum: indexPath.row)
        tableView.reloadData()
        //tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    //戻るボタン
    @IBAction func Back(_ sender: Any) {
        //deleteTagFromDB()
        //delegate?.sendDeleteTagList(deleteTagList: deletedList)
        delegate?.deleteTagFromTagView(deleteTagList: deletedList)
        dismiss(animated: true, completion: nil)
    }
    
    //タグを削除
    func deleteTag(cellNum:Int){
        deletedList.append(TagArray[cellNum])
        
        //配列の要素を削除
        TagArray.remove(at: cellNum)
        
        //DBから削除
        let realm = try! Realm()
        let objects = realm.objects(TagList.self)
        try! realm.write {
            realm.delete(objects[0].tags[cellNum])
        }
        
        deleteTagFromDB()
        
    }
    
    //DB上のデータのタグも削除する
    func deleteTagFromDB(){
        print("deleteTagFromDB")
        print(deletedList)
        let realm = try! Realm()
        let obs = realm.objects(FeedBack.self)
        
        try! realm.write{
            for ob in obs{
                //print(ob)
                for (index, tag) in ob.tags.enumerated() {
                    if deletedList.contains(tag.tag!) {
                        print("Match!", tag.tag!, index)
                        ob.tags.remove(at: index)
                    }
                }
            }
        }
        
        print("削除完了")
        print(obs)
    }
    
    
    func goEditVC(cellNum:Int){
        //present(EditTagViewController(), animated: true, completion: nil)
        performSegue(withIdentifier: "tag", sender: cellNum)
        cellNumber = cellNum
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editTagVC = segue.destination as! EditTagViewController
        editTagVC.delegate = self
        editTagVC.cellNum = sender as! Int
        editTagVC.isAddNewTag = isAddNewTag
        
        print(isAddNewTag)
    }
    
    
    //タグを編集 (delegateメソッド)
    func EditTag(tagString:String){
        
        let realm = try! Realm()
        let objects = realm.objects(TagList.self)
        
        try! realm.write({
            objects[0].tags[cellNumber]["tag"] = tagString
        })
        
        //タグを格納している配列初期化
        TagArray.removeAll()
        for tag in objects[0].tags{
            TagArray.append(tag["tag"] as! String)
        }
        
        tableView.reloadData()

    }
    
    //タグを追加 (delegateメソッド)
    func AddTag(tagString: String) {
        let realm = try! Realm()
        let objects = realm.objects(TagList.self)
        let newTag = Tag(value: ["tag": tagString])
        
        //DB追加
        try! realm.write({
            objects[0].tags.append(newTag)
        })
        
        //配列追加
        TagArray.append(tagString)
        
        print("追加後", objects)
        tableView.reloadData()
    
    }
    
    //タグ編集画面から戻る時にフラグをリセット
    func resetAddTagFlag(){
        isAddNewTag = false
    }
    
    //追加ボタン
    func prepareFABButton() {
        let button = FABButton(image: Icon.cm.add, tintColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.orange.base
        
        //view.layout(button).width(ButtonLayout.Fab.diameter).height(ButtonLayout.Fab.diameter)
        
        button.frame = CGRect(x: view.frame.size.width * 0.7, y: view.frame.size.height * 0.8, width: view.frame.size.width / 4.5, height: view.frame.size.width / 4.5)
        button.addTarget(self, action: #selector(addBarButtonTapped), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    //追加ボタンを押した時の処理
    @objc func addBarButtonTapped(_ sender: FABButton) {
        print("【+】ボタンが押された!")
        
        isAddNewTag = true
        performSegue(withIdentifier: "tag", sender: 0)
    }

    

}

