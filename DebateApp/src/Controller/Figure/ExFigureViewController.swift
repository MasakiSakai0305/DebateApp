//
//  ExViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/17.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import ScrollableGraphView

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
    
    
    var linePlotData = [Double()]
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //複数選択可
        tableView.allowsMultipleSelectionDuringEditing = true
        
        for i in 0..<100{
            linePlotData.append(Double(i) + Double.random(in: 0..<10))
        }
        linePlotData.append(1000.0)
        
        // Compose the graph view by creating a graph, then adding any plots
        // and reference lines before adding the graph to the view hierarchy.
        let graphView = ScrollableGraphView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/3), dataSource: self)
        //graphView.rangeMax = 100
        graphView.shouldAdaptRange = true
        graphView.backgroundFillColor = UIColor.black
        
        //デフォでture
        //graphView.shouldAnimateOnAdapt = true
        //graphView.shouldAnimateOnStartup = true
        
        let linePlot = LinePlot(identifier: "line") // Identifier should be unique for each plot.
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.lightGray
        linePlot.fillGradientEndColor = UIColor.darkGray
        
        let referenceLines = ReferenceLines()
        
        let barPlot = BarPlot(identifier: "bar")
        //barPlot.shouldRoundBarCorners = true
        barPlot.barColor = .red
    
        
        let dotPlot = DotPlot(identifier: "dot")
        dotPlot.dataPointType = ScrollableGraphViewDataPointType.circle
        dotPlot.dataPointFillColor = .white
        dotPlot.dataPointSize = 2

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
            return linePlotData[pointIndex]
        case "bar":
            return linePlotData[pointIndex]
        case "dot":
            return linePlotData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "04/21"
    }
    
    func numberOfPoints() -> Int {
        return linePlotData.count
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
