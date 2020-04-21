//
//  PieChartCell.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/17.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import Charts


//円グラフ(トータルの勝率)を描画
class PieChartCell: UITableViewCell {

    @IBOutlet weak var pieChartView: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awakeFromNib")
        
        //setPieGraph()
        
        let drawGraph = DrawGraph()
        drawGraph.setPieGraph(filter:"All", chartView:pieChartView, cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //円グラフセット
//    func setPieGraph(filter:String) {
//        pieChartView.usePercentValuesEnabled = true
//        let calc = ResultCalculation()
//        calc.resultCaluculation()
//        let date : [Double] = [1,2,3,4,5]
//        var entries: [ChartDataEntry] = Array()
//
//        switch filter {
//        case "All":
//            let values: [Double] = [calc.totalWinRate, 1 - calc.totalWinRate]
//            for (i, value) in values.enumerated(){
//                entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))}
//        case "NA":
//            let NARate: [Double] = [calc.NAWinRate, 1 - calc.NAWinRate]
//            for (i, value) in NARate.enumerated(){
//                entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))}
//        case "BP":
//            let BPRate: [Double] = [calc.BPWinRate, 1 - calc.BPWinRate]
//            for (i, value) in BPRate.enumerated(){
//                entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))}
//        case "Asian":
//            let AsianRate: [Double] = [calc.AsianWinRate, 1 - calc.AsianWinRate]
//            for (i, value) in AsianRate.enumerated(){
//                entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: self.classForCoder), compatibleWith: nil)))}
//        default:
//            print("Error :func setPieGraph(filter:String) in PieChartCell")
//        }
//        //let values: [Double] = [calc.totalWinRate, 1 - calc.totalWinRate]
//
//
//
//        print("entries")
//        print(entries)
//
//        let dataSet = PieChartDataSet(entries: entries, label: "勝率")
//
//        dataSet.colors = ChartColorTemplates.vordiplom()
//
//        let chartData = PieChartData(dataSet: dataSet)
//
//        pieChartView.data = chartData
//    }
    

}
