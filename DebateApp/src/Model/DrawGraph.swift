//
//  DrawGraph.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/21.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import Foundation
import Charts

class DrawGraph{
    
    //円グラフセット
    func setPieGraph(filter:String, chartView:PieChartView, cell:UITableViewCell) {
           chartView.usePercentValuesEnabled = true
           let calc = ResultCalculation()
           calc.resultCaluculation()
           let date : [Double] = [1,2,3,4,5]
           var entries: [ChartDataEntry] = Array()
           
           switch filter {
           case "All":
               let values: [Double] = [calc.totalWinRate, 100 - calc.totalWinRate]
               for (i, value) in values.enumerated(){
                   entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: cell.classForCoder), compatibleWith: nil)))}
           case "NA":
               let NARate: [Double] = [calc.NAWinRate, 100 - calc.NAWinRate]
               for (i, value) in NARate.enumerated(){
                   entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: cell.classForCoder), compatibleWith: nil)))}
           case "BP":
               let BPRate: [Double] = [calc.BPWinRate, 100 - calc.BPWinRate]
               for (i, value) in BPRate.enumerated(){
                   entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: cell.classForCoder), compatibleWith: nil)))}
           case "Asian":
                print(calc.AsianWinRate, 100 - calc.AsianWinRate)
               let AsianRate: [Double] = [calc.AsianWinRate, 100 - calc.AsianWinRate]
               for (i, value) in AsianRate.enumerated(){
                   entries.append(ChartDataEntry(x: date[i], y: value, icon: UIImage(named: "icon", in: Bundle(for: cell.classForCoder), compatibleWith: nil)))}
           default:
               print("Error :func setPieGraph(filter:String) in PieChartCell")
           }
           //let values: [Double] = [calc.totalWinRate, 1 - calc.totalWinRate]
           

           
           print("entries")
           print(entries)
               
           let dataSet = PieChartDataSet(entries: entries, label: "勝率")
               
           dataSet.colors = ChartColorTemplates.vordiplom()

           let chartData = PieChartData(dataSet: dataSet)
           
           chartView.data = chartData
       }
    
}
