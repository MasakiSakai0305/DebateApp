//
//  ExTagListTableViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/08.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift

protocol updateTagDelegate {
    func AddTagAndUpdateLayout(TagString:String)
}

class TagListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {

    

    @IBOutlet weak var bar: UINavigationBar!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var TagArray = [String]()
    var delegate:updateTagDelegate?
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        bar.frame = CGRect(x: 0, y: view.frame.size.height/30, width: view.frame.size.width, height: view.frame.size.height/15)
        bar.isTranslucent = false
        tableView.frame = CGRect(x: 0, y: view.frame.size.height/30 + bar.frame.size.height, width: view.frame.size.width, height: view.frame.size.height)
        
        let realm = try! Realm()
        let objects = realm.objects(TagList.self)
        
        for tag in objects[0].tags{
            TagArray.append(tag["tag"] as! String)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = TagArray[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.AddTagAndUpdateLayout(TagString: TagArray[indexPath.row])
        
        //navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
