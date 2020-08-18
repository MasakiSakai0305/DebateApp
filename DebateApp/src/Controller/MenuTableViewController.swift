//
//  MenuTableViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/23.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit

class MenuTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let menuArray = ["Style", "Role", "Motion Genre"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        cell.textLabel?.text = menuArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch menuArray[indexPath.row] {
        case "Style":
            print("push style")
             let StyleVC = storyboard?.instantiateViewController(withIdentifier: "Style")  as! StyleBaseViewController
            print("push style2")
            navigationController?.pushViewController(StyleVC, animated: true)
            print("push style3")
        case "Role":
            let RoleVC = storyboard?.instantiateViewController(withIdentifier: "Role")  as! RoleBaseViewController
            navigationController?.pushViewController(RoleVC, animated: true)
            
        case "Motion Genre":
            let GenreVC = storyboard?.instantiateViewController(withIdentifier: "Genre")  as! GenreBaseViewController
            navigationController?.pushViewController(GenreVC, animated: true)
        default:
            let StyleVC = storyboard?.instantiateViewController(withIdentifier: "Style")  as! StyleBaseViewController
            navigationController?.pushViewController(StyleVC, animated: true)
        }
       
    }

}
