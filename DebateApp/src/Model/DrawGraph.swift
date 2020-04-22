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
           var entries: [PieChartDataEntry] = Array()
    
        print("setPieGraph", calc.winCount, calc.totalCount - calc.winCount)
           
           switch filter {
           case "All":
            let values: [Double] = [calc.winCount, calc.totalCount - calc.winCount]
            print(values)
                entries.append(PieChartDataEntry(value: values[0], label: "勝ち"))
                entries.append(PieChartDataEntry(value: values[1], label: "負け"))
            print(values[0], values[1])
            
           case "NA":
               let NARate: [Double] = [calc.NAWinCount, calc.totalNACount - calc.NAWinCount]
               entries.append(PieChartDataEntry(value: NARate[0], label: "勝ち"))
               entries.append(PieChartDataEntry(value: NARate[1], label: "負け"))
           case "BP":
               let BPRate: [Double] = [calc.BPWinCount, calc.totalBPCount - calc.BPWinCount]
               entries.append(PieChartDataEntry(value: BPRate[0], label: "勝ち"))
               entries.append(PieChartDataEntry(value: BPRate[1], label: "負け"))
           case "Asian":
               let AsianRate: [Double] = [calc.AsianWinCount, calc.totalAsianCount - calc.AsianWinCount]
               entries.append(PieChartDataEntry(value: AsianRate[0], label: "勝ち"))
               entries.append(PieChartDataEntry(value: AsianRate[1], label: "負け"))
           default:
               print("Error :func setPieGraph(filter:String) in PieChartCell")
           }
           //let values: [Double] = [calc.totalWinRate, 1 - calc.totalWinRate]
           

           
           print("entries")
           print(entries)
               
           let dataSet = PieChartDataSet(entries: entries, label: "")
           dataSet.colors = ChartColorTemplates.vordiplom()

           let chartData = PieChartData(dataSet: dataSet)
           
           chartView.data = chartData
        
        
        // グラフのデータの値の色
        dataSet.valueTextColor = UIColor.black
        // グラフのデータのタイトルの色
        dataSet.entryLabelColor = UIColor.black
        
        //パーセント表示
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        chartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        chartView.usePercentValuesEnabled = true
        
        //グラフがぐるぐる動くのを無効化
        chartView.rotationEnabled = false
        //タップしてもハイライトをしない
        chartView.highlightPerTapEnabled = false
       }
    
}
