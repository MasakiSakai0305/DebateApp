//
//  FigureViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/15.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import Charts

class FigureViewController: UIViewController {

    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    var flag = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
        pieChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

        // Do any additional setup after loading the view.
        setPieGraph()
        //setBarGragh()
        self.view.bringSubviewToFront(pieChartView)
        //pieChartView.removeFromSuperview()
    }
    
    //円グラフセット
    func setPieGraph() {
            pieChartView.usePercentValuesEnabled = true
            
            let values: [Double] = [0, 1, 1, 1, 1]
            let date : [Double] = [1,2,3,4,5]
            var entries: [ChartDataEntry] = Array()
            for (i, value) in values.enumerated(){
                entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
            }
            
        let dataSet = PieChartDataSet(entries: entries, label: "ラベル")
            
            dataSet.colors = ChartColorTemplates.vordiplom()

            let chartData = PieChartData(dataSet: dataSet)
            
            pieChartView.data = chartData
        flag = "pie"
    }
    
    func setBarGragh(){
        let rawData: [Int] = [20, 50, 70, 30, 60, 90, 40]
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        flag = "bar"
        
    }
    
    
    @IBAction func switchChart(_ sender: Any) {
        if flag == "pie"{
            //self.view.addSubview(barChartView!)
            //pieChartView.removeFromSuperview()
            self.view.bringSubviewToFront(barChartView)
            setBarGragh()
        } else if flag == "bar"{
            //self.view.addSubview(pieChartView)
            //barChartView.removeFromSuperview()
            self.view.bringSubviewToFront(pieChartView)
            setPieGraph()

        }
        
    }
    
    


}