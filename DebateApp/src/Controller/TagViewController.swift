//
//  TagViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/06.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import TagListView

class TagViewController: UIViewController, UITextFieldDelegate, TagListViewDelegate, updateTagDelegate {
    func sendDeleteTagList(deleteTagList: [String]) {
        print(1)
    }
    
    func deleteTagFromTagView(deleteTagList:[String]) {
        print(1)
    }
    

    
    

    let MARGIN: CGFloat = 10

    let tagListView = TagListView()
    let textField = UITextField()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
        
        print("view.frame.size", view.frame.size)
        tagListView.delegate = self
//        tagListView.taghei
        var TagArray = [String]()
        print(TagArray)
    }
    
    
    func setView() {

        view.addSubview(tagListView)
        view.addSubview(textField)

        tagListView.frame = CGRect(x: MARGIN, y: 100, width: view.frame.width-MARGIN*2, height: 0)

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

        // テキストフィールドは適当にセット
        textField.delegate = self
        textField.placeholder = "タグを入力してください"
        textField.returnKeyType = UIReturnKeyType.done

        // レイアウト調整
        updateLayout()
    }

    // テキストフィールドの完了ボタンが押されたら
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if 0 < textField.text!.count {
            // タグを追加
            tagListView.addTag(textField.text!)

            // テキストフィールドをクリアしてレイアウト調整
            textField.text = nil
            updateLayout()
        }
        return true
    }
    
    //タグを追加
    func AddTagAndUpdateLayout(TagString:String, deleteTagList:[String]) {
        print("AddTagAndUpdateLayout")
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
        if tagListView.tagViews.count > 0{
            print((tagListView.tagViews[0].titleLabel!.text!))
            for tagView in tagListView.tagViews{
                print(tagView.frame)
            }
           }
        //print(tagListView.)
        // タグ全体の高さを取得
        tagListView.frame.size = tagListView.intrinsicContentSize
        
        print("tagListView.frame.size", tagListView.frame.size)
        if tagListView.frame.size.height >= 60{
            //tagListView.frame.size.height = 60
            print("if")
        }

        textField.frame = CGRect(x: MARGIN, y: tagListView.frame.origin.y + tagListView.frame.height + 5, width: view.frame.width-MARGIN*2, height: 40)
    }
    
    
    @IBAction func GoTagList(_ sender: Any) {
        
        let TagListVC = storyboard?.instantiateViewController(withIdentifier: "Tag")  as! TagListTableViewController
        TagListVC.delegate = self

                          
        //画面遷移
        navigationController?.pushViewController(TagListVC, animated: true)
    }
    


}
