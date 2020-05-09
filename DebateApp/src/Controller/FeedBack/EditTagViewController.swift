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
}

class EditTagViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var tagTextField: UITextField!
    
    var delegate:EditTagDelegate?
    
    var cellNum = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tagTextField.delegate = self
        
        tagTextField.frame = CGRect(x: view.frame.size.width/20, y: view.frame.size.height/5, width: view.frame.size.width, height: view.frame.size.height/15)
        tagTextField.font =  UIFont.systemFont(ofSize: 15)
        
        let realm = try! Realm()
        let objects = realm.objects(TagList.self)
        tagTextField.text = objects[0].tags[cellNum]["tag"]! as? String
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        delegate?.EditTag(tagString:tagTextField.text!)
        
        dismiss(animated: true, completion: nil)
        return true
    }
    
}
