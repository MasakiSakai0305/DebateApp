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
        tableView.register(UINib(nibName: "AsianPieChartViewCell2", bundle: nil), forCellReuseIdentifier: "Asian")
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //円グラフを表示するカスタムセル
        switch indexPath[0] {
        case 0:
            let totalCell = tableView.dequeueReusableCell(withIdentifier: "pie", for: indexPath) as! PieChartCell
            totalCell.pieChartView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2.5)
            return totalCell
        case 1:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "bar", for: indexPath) as! BarChartwCell
            return cell1
        case 2:
            let NACell = tableView.dequeueReusableCell(withIdentifier: "NA", for: indexPath) as! NAPieChartViewCell
            NACell.pieChartView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2.5)
            return NACell
        case 3:
            let BPCell = tableView.dequeueReusableCell(withIdentifier: "BP", for: indexPath) as! BPPieChartViewCell
            BPCell.pieChartView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2.5)
            return BPCell
        case 4:
            let AsianCell = tableView.dequeueReusableCell(withIdentifier: "Asian", for: indexPath) as! AsianPieChartViewCell
            AsianCell.pieChartView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/2.5)
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
