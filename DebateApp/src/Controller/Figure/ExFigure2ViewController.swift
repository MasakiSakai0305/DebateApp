//
//  ExFigure2ViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/17.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit

class ExFigure2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PieChartCell", bundle: nil), forCellReuseIdentifier: "pie")
        tableView.register(UINib(nibName: "BarChartwCell", bundle: nil), forCellReuseIdentifier: "bar")
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("--cellForRowAt--: ", indexPath.row)
        print("indexPath: ", indexPath, indexPath[0])

//        if indexPath.row == 0{
//
//             cell = tableView.dequeueReusableCell(withIdentifier: "pie", for: indexPath) as! PieChartCell
//
//
//        } else if indexPath.row == 1{
//            print(1)
//             cell = tableView.dequeueReusableCell(withIdentifier: "bar", for: indexPath) as! BarChartwCell
//        }
            switch indexPath[0] {
            case 0:
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "pie", for: indexPath) as! PieChartCell
                return cell1
            case 1:
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "bar", for: indexPath) as! BarChartwCell
                return cell2
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "pie", for: indexPath) as! PieChartCell
                return cell
            }
            
        
        
    
        //print(objectArray[indexPath.row].MotionTitle!)
        //cell.MotionLabel.text = objectArray[indexPath.row].MotionTitle
    
        
    }
    
    //高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/2
    }
    

}
