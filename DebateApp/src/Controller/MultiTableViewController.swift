//
//  MultiTableViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/01.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import Material

struct ButtonLayout {
    struct Flat {
        static let width: CGFloat = 120
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -150
    }
    
    struct Raised {
        static let width: CGFloat = 150
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -75
    }
    
    struct Fab {
        static let diameter: CGFloat = 48
    }
    
    struct Icon {
        static let width: CGFloat = 120
        static let height: CGFloat = 48
        static let offsetY: CGFloat = 75
    }
}

class MultiTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
 var deleteArray: [String] = ["にんじん", "たまねぎ", "じゃがいも", "ルー", "肉", "米", "はちみつ", "りんご", "スプーン", "皿"]
    
 var numbers = [Int()]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.editButtonItem.title = "編集"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //複数選択可能(これがないと単一選択になる)
        tableView.allowsMultipleSelectionDuringEditing = true
        
        prepareFlatButton()
        prepareRaisedButton()
        prepareFABButton()
        prepareIconButton()
        
    }
    
    func prepareFlatButton() {
        let button = FlatButton(title: "Flat Button")
        
        view.layout(button)
            .width(ButtonLayout.Flat.width)
            .height(ButtonLayout.Flat.height)
            .center(offsetY: ButtonLayout.Flat.offsetY)
    }
    
    func prepareRaisedButton() {
        let button = RaisedButton(title: "Raised Button", titleColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.blue.base
        
        view.layout(button)
            .width(ButtonLayout.Raised.width)
            .height(ButtonLayout.Raised.height)
            .center(offsetY: ButtonLayout.Raised.offsetY)
        
        
    }
    
    @objc func action(_ sender: FABButton){
        print("ボタンが押された")
    }
    
    func prepareFABButton() {
        let button = FABButton(image: Icon.cm.add, tintColor: .white)
        button.pulseColor = .white
        button.backgroundColor = Color.green.base
        
        //view.layout(button).width(ButtonLayout.Fab.diameter).height(ButtonLayout.Fab.diameter)
        
        button.frame = CGRect(x: view.frame.size.width/2, y: view.frame.size.height * 0.8, width: ButtonLayout.Fab.diameter, height: ButtonLayout.Fab.diameter)
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        view.addSubview(button)
    }
    
    
    
    func prepareIconButton() {
        let button = IconButton(image: Icon.cm.search)
        
        view.layout(button)
            .width(ButtonLayout.Icon.width)
            .height(ButtonLayout.Icon.height)
            .center(offsetY: ButtonLayout.Icon.offsetY)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deleteArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "test:\(deleteArray[indexPath.row])"

        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        print("setEditing")
        if editing {
            // 編集開始
            print("編集開始")
            self.editButtonItem.title = "完了"
        } else {
            // 編集終了
            print("編集終了")
            self.editButtonItem.title = "編集"
            self.deleteRows()
        }
        
        // 編集モード時のみ複数選択可能とする
        tableView.isEditing = editing
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 編集モードじゃない場合はreturn
        guard tableView.isEditing else {
            print("return didSelectRowAt")
            return }
        
        if let _ = self.tableView.indexPathsForSelectedRows {
            // 選択肢にチェックが一つでも入ってたら「削除」を表示する。
            print("didSelectRowAt")
            self.editButtonItem.title = "削除"
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
    
    private func deleteRows() {
        guard let selectedIndexPaths = self.tableView.indexPathsForSelectedRows else {
            return
        }
        
        print("selectedIndexPaths")
        print(selectedIndexPaths)
        for indexPathList in selectedIndexPaths{
            print(indexPathList.row)
        }
        // 配列の要素削除で、indexの矛盾を防ぐため、降順にソートする
        let sortedIndexPaths =  selectedIndexPaths.sorted { $0.row > $1.row }
        for indexPathList in sortedIndexPaths {
            deleteArray.remove(at: indexPathList.row) // 選択肢のindexPathから配列の要素を削除
        }
        
        // tableViewの行を削除
        tableView.deleteRows(at: sortedIndexPaths, with: UITableView.RowAnimation.automatic)
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
