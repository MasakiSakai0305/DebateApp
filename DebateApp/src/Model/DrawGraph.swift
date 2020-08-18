//
//  DrawGraph.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/21.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import Foundation
import Charts
import ScrollableGraphView


class DrawGraph{
    
    
    //円グラフセット
    func setPieGraph(filter:String, chartView:PieChartView, cell:UITableViewCell) {
           chartView.usePercentValuesEnabled = true
           let calc = ResultCalculation()
        print("resultCaluculation func called in DrawGraph.setPieGraph")
           calc.resultCaluculation()
           //let date : [Double] = [1,2,3,4,5]
           var entries: [PieChartDataEntry] = Array()

           
           switch filter {
           case "All":
                let values: [Double] = [calc.winCount, calc.totalCount - calc.winCount]
                entries.append(PieChartDataEntry(value: values[0], label: "勝ち"))
                entries.append(PieChartDataEntry(value: values[1], label: "負け"))
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
        //真ん中を塗りつぶす
        chartView.drawHoleEnabled = false
        
        
       }
  
}

class DrawScoreGraph: ScrollableGraphViewDataSource{

    var plotScore = [Double()]
    var plotDate = [String()]
    
    init(score:[Double], date:[String]){
        plotScore = score
        plotDate = date
    }

    func drawScoreGraph(cell:UITableViewCell, ViewWidth:CGFloat, ViewHeight:CGFloat){

        let graphView = ScrollableGraphView(frame: CGRect(x: 0, y: 0, width: ViewWidth, height: ViewHeight), dataSource: self)
        graphView.rangeMax = 85
        graphView.rangeMin = 65
      //graphView.shouldAdaptRange = true
        graphView.backgroundFillColor = UIColor(hex: "333333")
        graphView.dataPointSpacing = 50
        
        //デフォでture
        graphView.shouldAnimateOnAdapt = false
        graphView.shouldAnimateOnStartup = false

        let linePlot = LinePlot(identifier: "line") // Identifier should be unique for each plot.
        linePlot.lineStyle = ScrollableGraphViewLineStyle.straight
        linePlot.lineColor = UIColor(hex: "16aafc")
        
        let dotPlot = DotPlot(identifier: "dot")
        dotPlot.dataPointType = ScrollableGraphViewDataPointType.circle
        dotPlot.dataPointFillColor = .systemBlue
        dotPlot.dataPointSize = 4
        
        let referenceLines = ReferenceLines()
        referenceLines.relativePositions = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6,0.7, 0.8, 0.9, 1]
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        referenceLines.dataPointLabelBottomMargin = 30

        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)

        cell.addSubview(graphView)
      
    }

    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return plotScore[pointIndex]
    }

    func label(atIndex pointIndex: Int) -> String {
        return plotDate[pointIndex]
    }

    func numberOfPoints() -> Int {
        return plotScore.count
    }

}

//class ExFigureViewController: UIViewController, ScrollableGraphViewDataSource, UITableViewDelegate, UITableViewDataSource{
//
//
//    @IBOutlet weak var tableView: UITableView!
//    var tableData:[String] = [
//        "1. Apple",
//        "2. Swift",
//        "3. iPad",
//        "4. iPhone",
//        "5. MacBook"
//    ]
//
//    //プロットするデータ(スコア)
//    var TotalPlotScore = [Double()]
//    var NAPlotScore = [Double()]
//    var BPPlotScore = [Double()]
//    var AsianPlotScore = [Double()]
//
//    //プロットするデータ(日付)
//    var TotalPlotDate = [String()]
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        //複数選択可
//        tableView.allowsMultipleSelectionDuringEditing = true
//
//
//        //降順のソート（日付が新しい物が上に来る）
//        //let TotalObjects = realm.objects(FeedBack.self).sorted(byKeyPath: "date", ascending: false)
//
//        let realm = try! Realm()
//        let TotalObjects = realm.objects(FeedBack.self).sorted(byKeyPath: "date")
//        let NAObjects = realm.objects(FeedBack.self).filter("style == 'NA'").sorted(byKeyPath: "date", ascending: false)
//        let BPObjects = realm.objects(FeedBack.self).filter("style == 'BP'").sorted(byKeyPath: "date", ascending: false)
//        let AsianObjects = realm.objects(FeedBack.self).filter("style == 'Asian'").sorted(byKeyPath: "date", ascending: false)
//
//        //DBを読んで配列にデータを追加
//        for i in 0..<TotalObjects.count{
//            TotalPlotScore.append(Double(TotalObjects[i].score))
//            TotalPlotDate.append(TotalObjects[i].date.components(separatedBy: "年/")[1])
//
//        }
//        for i in 0..<NAObjects.count{
//            NAPlotScore.append(Double(TotalObjects[i].score))
//        }
//        for i in 0..<BPObjects.count{
//            BPPlotScore.append(Double(BPObjects[i].score))
//        }
//        for i in 0..<AsianObjects.count{
//            AsianPlotScore.append(Double(AsianObjects[i].score))
//        }
//
//        //一番最初に0が入ってしまうので削除
//        TotalPlotScore.remove(at: 0)
//        NAPlotScore.remove(at: 0)
//        BPPlotScore.remove(at: 0)
//        AsianPlotScore.remove(at: 0)
//
//        TotalPlotDate.remove(at: 0)
//
//
//        // Compose the graph view by creating a graph, then adding any plots
//        // and reference lines before adding the graph to the view hierarchy.
//        let graphView = ScrollableGraphView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2), dataSource: self)
//        graphView.rangeMax = 85
//        graphView.rangeMin = 65
//       //graphView.shouldAdaptRange = true
//        graphView.backgroundFillColor = UIColor(hex: "333333")
//
//        graphView.dataPointSpacing = 50
//
//        //デフォでture
//        graphView.shouldAnimateOnAdapt = false
//        graphView.shouldAnimateOnStartup = false
//
//        let linePlot = LinePlot(identifier: "line") // Identifier should be unique for each plot.
//        linePlot.lineStyle = ScrollableGraphViewLineStyle.straight
//        linePlot.lineColor = UIColor(hex: "16aafc")
//
//
////        linePlot.shouldFill = true
////        linePlot.fillType = ScrollableGraphViewFillType.gradient
////        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
////        linePlot.fillGradientStartColor = UIColor.lightGray
////        linePlot.fillGradientEndColor = UIColor.darkGray
////
//        let referenceLines = ReferenceLines()
//        referenceLines.relativePositions = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6,0.7, 0.8, 0.9, 1]
//
//        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
//        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
//        referenceLines.referenceLineLabelColor = UIColor.white
//        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
//
//        let barPlot = BarPlot(identifier: "bar")
//        //barPlot.shouldRoundBarCorners = true
//        barPlot.barColor = .red
//
//
//        let dotPlot = DotPlot(identifier: "dot")
//        dotPlot.dataPointType = ScrollableGraphViewDataPointType.circle
//        dotPlot.dataPointFillColor = .systemBlue
//        dotPlot.dataPointSize = 4
//
//        graphView.addPlot(plot: linePlot)
////        graphView.addPlot(plot: barPlot)
//        graphView.addPlot(plot: dotPlot)
//        graphView.addReferenceLines(referenceLines: referenceLines)
//
//        self.view.addSubview(graphView)
//
//    }
//
//
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        tableView.isEditing = editing
//
//        print(editing)
//    }
//
//
//
//    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
//        // Return the data for each plot.
//        switch(plot.identifier) {
//        case "line":
//            return TotalPlotScore[pointIndex]
//        case "bar":
//            return TotalPlotScore[pointIndex]
//        case "dot":
//            return TotalPlotScore[pointIndex]
//        default:
//            return 0
//        }
//    }
//
//    func label(atIndex pointIndex: Int) -> String {
//        return TotalPlotDate[pointIndex]
//    }
//
//    func numberOfPoints() -> Int {
//        return TotalPlotScore.count
//    }
//
//
