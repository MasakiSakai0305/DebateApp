//
//  ExFigure2ViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/17.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit


class GraphScrollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PieChartCell", bundle: nil), forCellReuseIdentifier: "pie")
        tableView.register(UINib(nibName: "BarChartwCell", bundle: nil), forCellReuseIdentifier: "bar")
        tableView.register(UINib(nibName: "NAPieChartViewCell", bundle: nil), forCellReuseIdentifier: "NA")
        tableView.register(UINib(nibName: "BPPieChartViewCell", bundle: nil), forCellReuseIdentifier: "BP")
        tableView.register(UINib(nibName: "AsianPieChartViewCell", bundle: nil), forCellReuseIdentifier: "Asian")
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("--cellForRowAt--: ", indexPath.row)
        print("indexPath: ", indexPath, indexPath[0])

        
        switch indexPath[0] {
        case 0:
            let cell0 = tableView.dequeueReusableCell(withIdentifier: "pie", for: indexPath) as! PieChartCell
            return cell0
        case 1:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "bar", for: indexPath) as! BarChartwCell
            return cell1
        case 2:
            let NACell = tableView.dequeueReusableCell(withIdentifier: "NA", for: indexPath) as! NAPieChartViewCell
            return NACell
        case 3:
            let BPCell = tableView.dequeueReusableCell(withIdentifier: "BP", for: indexPath) as! BPPieChartViewCell
            return BPCell
        case 4:
            let AsianCell = tableView.dequeueReusableCell(withIdentifier: "Asian", for: indexPath) as! AsianPieChartViewCell
            return AsianCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pie", for: indexPath) as! PieChartCell
            print("Error indexPath: ", indexPath)
            return cell
        }
        
    
    
        
    }
    
    //高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/2
    }
    

}
