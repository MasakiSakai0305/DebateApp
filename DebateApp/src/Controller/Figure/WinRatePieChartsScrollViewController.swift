//
//  ExFigure2ViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/17.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit


class WinRatePieChartsScrollViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var calc = ResultCalculation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PieChartCell", bundle: nil), forCellReuseIdentifier: "pie")
        tableView.register(UINib(nibName: "BarChartwCell", bundle: nil), forCellReuseIdentifier: "bar")
        tableView.register(UINib(nibName: "NAPieChartViewCell", bundle: nil), forCellReuseIdentifier: "NA")
        tableView.register(UINib(nibName: "BPPieChartViewCell", bundle: nil), forCellReuseIdentifier: "BP")
        tableView.register(UINib(nibName: "AsianPieChartViewCell2", bundle: nil), forCellReuseIdentifier: "Asian")
        
        calc.resultCaluculationByStyle()
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
            totalCell.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height/2)
            
            totalCell.pieChartView.frame = CGRect(x: 0, y: 0, width: totalCell.frame.size.width, height: totalCell.frame.size.height * 0.9)
            totalCell.resultLabel.text = "Total 勝利:\(Int(calc.winCount)),  敗北:\(Int(calc.loseCount))"
            totalCell.resultLabel.frame = CGRect(x:  totalCell.frame.size.width * 0.5, y: totalCell.frame.size.height * 0.8, width: totalCell.frame.size.width/2, height: totalCell.frame.size.height/5)
            return totalCell
            
        case 1:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "bar", for: indexPath) as! BarChartwCell
            return cell1
            
        case 2:
            let NACell = tableView.dequeueReusableCell(withIdentifier: "NA", for: indexPath) as! NAPieChartViewCell
            NACell.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height/2)
            
            NACell.pieChartView.frame = CGRect(x: 0, y: 0, width: NACell.frame.size.width, height: NACell.frame.size.height * 0.9)
            NACell.resultLabel.text = "NA 勝利:\(Int(calc.NAWinCount)),  敗北:\(Int(calc.NALoseCount))"
            NACell.resultLabel.frame = CGRect(x:  NACell.frame.size.width * 0.5, y: NACell.frame.size.height * 0.8, width: NACell.frame.size.width/2, height: NACell.frame.size.height/5)
            return NACell
            
        case 3:
            let BPCell = tableView.dequeueReusableCell(withIdentifier: "BP", for: indexPath) as! BPPieChartViewCell
            BPCell.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height/2)
            
            BPCell.pieChartView.frame = CGRect(x: 0, y: 0, width: BPCell.frame.size.width, height: BPCell.frame.size.height * 0.9)
            BPCell.resultLabel.text = "BP 勝利:\(Int(calc.BPWinCount)),  敗北:\(Int(calc.BPLoseCount))"
            BPCell.resultLabel.frame = CGRect(x:  BPCell.frame.size.width * 0.5, y: BPCell.frame.size.height * 0.8, width: BPCell.frame.size.width/2, height: BPCell.frame.size.height/5)
            return BPCell
            
        case 4:
            let AsianCell = tableView.dequeueReusableCell(withIdentifier: "Asian", for: indexPath) as! AsianPieChartViewCell
            AsianCell.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height/2)
            
            AsianCell.pieChartView.frame = CGRect(x: 0, y: 0, width: AsianCell.frame.size.width, height: AsianCell.frame.size.height * 0.8)
            AsianCell.resultLabel.text = "Asian 勝利:\(Int(calc.AsianWinCount)),  敗北:\(Int(calc.AsianLoseCount))"
            //一番下だけ見えにくくなるので数値を少し変更
            AsianCell.resultLabel.frame = CGRect(x:  AsianCell.frame.size.width * 0.5, y: AsianCell.frame.size.height * 0.7, width: AsianCell.frame.size.width/2, height: AsianCell.frame.size.height/5)
            return AsianCell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pie", for: indexPath) as! PieChartCell
            print("Error cellForRowAt pieGraph")
            print("Error indexPath: ", indexPath)
            return cell
        }
        
    
    
        
    }
    
    //高さを決める
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height/2
    }
    

}
