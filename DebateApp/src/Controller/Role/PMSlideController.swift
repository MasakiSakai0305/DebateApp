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
        tableView.register(UINib(nibName: "PMScoreCell", bundle: nil), forCellReuseIdentifier: "PMScore")
        //勝敗を描画するセル
        tableView.register(UINib(nibName: "PMPieChartViewCell", bundle: nil), forCellReuseIdentifier: "PMWinRate")
        self.view.addSubview(tableView)
        
        print("resultCaluculation func called in PMSlideController.viewDidLoad")
        calc.resultCaluculationByRole()
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath[0] {
            case 0:
                let PMScoreCell = tableView.dequeueReusableCell(withIdentifier: "PMScore", for: indexPath) as! PMScoreCell
                PMScoreCell.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height/2)
                
                PMScoreCell.width = view.frame.size.width
                PMScoreCell.height = view.frame.size.height * 0.7
                PMScoreCell.callDrawMethod()
                return PMScoreCell
                
            case 1:
                let PMWinRateCell = tableView.dequeueReusableCell(withIdentifier: "PMWinRate", for: indexPath) as! PMPieChartViewCell
                PMWinRateCell.frame.size = CGSize(width: view.frame.size.width, height: view.frame.size.height/2)
                
                PMWinRateCell.PMPieChartView.frame = CGRect(x: 0, y: 0, width: PMWinRateCell.frame.size.width, height: PMWinRateCell.frame.size.height * 0.9)
                PMWinRateCell.resultLabel.text = "PM 勝利:\(Int(calc.PMWinCount)),  敗北:\(Int(calc.PMLoseCount))"
                print("calc.PMWinCount:", calc.PMWinCount)
                PMWinRateCell.resultLabel.frame = CGRect(x:  PMWinRateCell.frame.size.width * 0.5, y: PMWinRateCell.frame.size.height * 0.8, width: PMWinRateCell.frame.size.width/2, height: PMWinRateCell.frame.size.height/5)
                return PMWinRateCell
            
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
