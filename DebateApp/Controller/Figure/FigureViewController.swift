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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupGraph()
    }
    
    //円グラフセット
    func setupGraph() {
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
    }
    
    


}
