//
//  ExViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/17.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import ScrollableGraphView
import RealmSwift


extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}

//グラフ描画試し

class ExFigureViewController: UIViewController, ScrollableGraphViewDataSource, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    var tableData:[String] = [
        "1. Apple",
        "2. Swift",
        "3. iPad",
        "4. iPhone",
        "5. MacBook"
    ]
    
    //プロットするデータ
    var TotalPlotData = [Double()]
    var NAPlotData = [Double()]
    var BPPlotData = [Double()]
    var AsianPlotData = [Double()]
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //複数選択可
        tableView.allowsMultipleSelectionDuringEditing = true
        
        
        let realm = try! Realm()
        let TotalObjects = realm.objects(FeedBack.self).sorted(byKeyPath: "date", ascending: false)
        let NAObjects = realm.objects(FeedBack.self).filter("style == 'NA'").sorted(byKeyPath: "date", ascending: false)
        let BPObjects = realm.objects(FeedBack.self).filter("style == 'BP'").sorted(byKeyPath: "date", ascending: false)
        let AsianObjects = realm.objects(FeedBack.self).filter("style == 'Asian'").sorted(byKeyPath: "date", ascending: false)
        
        
        //DBを読んで配列にデータを追加
        for i in 0..<TotalObjects.count{
            TotalPlotData.append(Double(TotalObjects[i].score))
        }
        for i in 0..<NAObjects.count{
            NAPlotData.append(Double(TotalObjects[i].score))
        }
        for i in 0..<BPObjects.count{
            BPPlotData.append(Double(BPObjects[i].score))
        }
        for i in 0..<AsianObjects.count{
            AsianPlotData.append(Double(AsianObjects[i].score))
        }
        
        //一番最初に0が入ってしまうので削除
        TotalPlotData.remove(at: 0)
        NAPlotData.remove(at: 0)
        BPPlotData.remove(at: 0)
        AsianPlotData.remove(at: 0)
    
        
        // Compose the graph view by creating a graph, then adding any plots
        // and reference lines before adding the graph to the view hierarchy.
        let graphView = ScrollableGraphView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2), dataSource: self)
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
        
        
//        linePlot.shouldFill = true
//        linePlot.fillType = ScrollableGraphViewFillType.gradient
//        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
//        linePlot.fillGradientStartColor = UIColor.lightGray
//        linePlot.fillGradientEndColor = UIColor.darkGray
//
        let referenceLines = ReferenceLines()
        referenceLines.relativePositions = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6,0.7, 0.8, 0.9, 1]
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        let barPlot = BarPlot(identifier: "bar")
        //barPlot.shouldRoundBarCorners = true
        barPlot.barColor = .red
    
        
        let dotPlot = DotPlot(identifier: "dot")
        dotPlot.dataPointType = ScrollableGraphViewDataPointType.circle
        dotPlot.dataPointFillColor = .systemBlue
        dotPlot.dataPointSize = 4

        graphView.addPlot(plot: linePlot)
//        graphView.addPlot(plot: barPlot)
        graphView.addPlot(plot: dotPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        self.view.addSubview(graphView)

    }

    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = editing

        print(editing)
    }
    
    
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "line":
            return TotalPlotData[pointIndex]
        case "bar":
            return TotalPlotData[pointIndex]
        case "dot":
            return TotalPlotData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(pointIndex)\n(04/21)"
    }
    
    func numberOfPoints() -> Int {
        return TotalPlotData.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = self.tableData[indexPath.row]
        return cell

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("indexPath.row: \(indexPath.row) 削除")
        // 先にデータを削除しないと、エラーが発生します。
        self.tableData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
}



//extension ExFigureViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel!.text = self.tableData[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.tableData.count
//    }
//}
//
//extension ExFigureViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        // 先にデータを削除しないと、エラーが発生します。
//        self.tableData.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .automatic)
//    }
//}