//
//  PMSlideController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/06/18.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import SegementSlide

class PMSlideController: UIViewController, SegementSlideContentScrollViewDelegate, UITableViewDelegate, UITableViewDataSource{
    
    var tableView = UITableView()
    var calc = ResultCalculation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: view.frame.size.height/15, width: view.frame.size.width, height: view.frame.size.height * 0.95)
        //スコアを描画するセル
        tableView.register(UINib(nibName: "NAScoreCell", bundle: nil), forCellReuseIdentifier: "NAScore")
        //勝敗を描画するセル
        tableView.register(UINib(nibName: "NAPieChartViewCell", bundle: nil), forCellReuseIdentifier: "NA")
        self.view.addSubview(tableView)
        
        print("resultCaluculation func called in PMSlideController.viewDidLoad")
        calc.resultCaluculationByRole()
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath[0] {
            case 0:
                let NAScoreCell = tableView.dequeueReusableCell(withIdentifier: "NAScore", for: indexPath) as! NAScoreCell
                NAScoreCell.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height/2)
                
                NAScoreCell.width = view.frame.size.width
                NAScoreCell.height = view.frame.size.height * 0.7
                NAScoreCell.callDrawMethod()
                return NAScoreCell
                
            case 1:
                let NAWinRateCell = tableView.dequeueReusableCell(withIdentifier: "NA", for: indexPath) as! NAPieChartViewCell
                NAWinRateCell.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height/2)
                
                NAWinRateCell.pieChartView.frame = CGRect(x: 0, y: 0, width: NAWinRateCell.frame.size.width, height: NAWinRateCell.frame.size.height * 0.9)
                NAWinRateCell.resultLabel.text = "NA 勝利:\(Int(calc.NAWinCount)),  敗北:\(Int(calc.NALoseCount))"
                print("calc.NAWinCount:", calc.NAWinCount)
                NAWinRateCell.resultLabel.frame = CGRect(x:  NAWinRateCell.frame.size.width * 0.5, y: NAWinRateCell.frame.size.height * 0.8, width: NAWinRateCell.frame.size.width/2, height: NAWinRateCell.frame.size.height/5)
                return NAWinRateCell
            
            default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NAScore", for: indexPath) as! PieChartCell
            print("Error cellForRowAt NAScore")
            print("Error indexPath: ", indexPath)
            return cell
        }
    
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }


}
