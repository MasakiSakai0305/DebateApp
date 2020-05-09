//
//  EditTagViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/09.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift

protocol EditTagDelegate {
    func EditTag(tagString:String)
    func AddTag(tagString:String)
    func resetAddTagFlag()
}

class EditTagViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var tagTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate:EditTagDelegate?
    
    var cellNum = Int()
    
    var isAddNewTag = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tagTextField.delegate = self
        
        tagTextField.frame = CGRect(x: view.frame.size.width/20, y: view.frame.size.height/5, width: view.frame.size.width, height: view.frame.size.height/15)
        tagTextField.font =  UIFont.systemFont(ofSize: 15)
        
        titleLabel.frame = CGRect(x:0, y: 0, width: view.frame.size.width, height: view.frame.size.height/5)
        titleLabel.font =  UIFont(name: "Copperplate-Bold", size: 35)
        
        let realm = try! Realm()
        let objects = realm.objects(TagList.self)
        
        if isAddNewTag == false {
            tagTextField.text = objects[0].tags[cellNum]["tag"]! as? String
            titleLabel.text = "タグ編集"
        } else {
            titleLabel.text = "タグ追加"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //追加処理
        if isAddNewTag == true{
            delegate?.AddTag(tagString: tagTextField.text!)
            
        //編集処理
        } else {
            delegate?.EditTag(tagString:tagTextField.text!)
        }
        
        dismiss(animated: true, completion: nil)
        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        
        delegate?.resetAddTagFlag()
    }
}
