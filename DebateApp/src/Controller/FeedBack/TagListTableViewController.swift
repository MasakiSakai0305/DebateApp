//
//  ExTagListTableViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/08.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit

protocol updateTagDelegate {
    func AddTagAndUpdateLayout(TagString:String)
}

class TagListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {

    

    @IBOutlet weak var bar: UINavigationBar!
    
    var Array = ["a", "b", "c"]
    var delegate:updateTagDelegate?
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        bar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/20)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = Array[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.AddTagAndUpdateLayout(TagString: Array[indexPath.row])
        
        //navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

}
