//
//  PieChartCell.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/17.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import Charts

class PieChartCell: UITableViewCell {

    @IBOutlet weak var pieChartView: PieChartView!
    
    var flag = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awakeFromNib")
        
        setPieGraph()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //円グラフセット
    func setPieGraph() {
        pieChartView.usePercentValuesEnabled = true
        let calc = ResultCalculation()
        calc.resultCaluculation()
        let values: [Double] = [calc.totalWinRate, 1 - calc.totalWinRate]
        let date : [Double] = [1,2,3,4,5]
        var entries: [ChartDataEntry] = Array()
        for (i, value) in values.enumerated(){
            entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))
        }
        
        print("entries")
        print(entries)
            
        let dataSet = PieChartDataSet(entries: entries, label: "勝率")
            
        dataSet.colors = ChartColorTemplates.vordiplom()

        let chartData = PieChartData(dataSet: dataSet)
        
        pieChartView.data = chartData
        flag = "pie"
    }
}
