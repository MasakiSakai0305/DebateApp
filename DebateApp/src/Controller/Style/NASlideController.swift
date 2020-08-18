//
//  StyleViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/22.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import SegementSlide
import RealmSwift
import ScrollableGraphView

class NASlideController: UIViewController ,SegementSlideContentScrollViewDelegate, ScrollableGraphViewDataSource{
    
    
    var NAScoreDictArray = [Dictionary<String, Int>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let TotalObjects = realm.objects(FeedBack.self).sorted(byKeyPath: "date")
        let NAObjects = realm.objects(FeedBack.self).filter("style == 'NA'").sorted(byKeyPath: "date", ascending: false)
        let BPObjects = realm.objects(FeedBack.self).filter("style == 'BP'").sorted(byKeyPath: "date", ascending: false)
        let AsianObjects = realm.objects(FeedBack.self).filter("style == 'Asian'").sorted(byKeyPath: "date", ascending: false)
        print(NAObjects)
        
//        var NAScoreDictArray = [Dictionary<String, Int>]()
//        for NAobject in NAObjects{
//            //print(NAobject.date,NAobject.score)
//            //if NAobject.date! in NAScoreDict.keys {
//                //NAScoreDict[NAobject.date!]
//            NAScoreDictArray.append([NAobject.date!:NAobject.score])
//        }
//
//        print(NAScoreDictArray)
        
        NAScoreDictArray = makeNAScoreDictArray()
        print(NAScoreDictArray)
        print(NAScoreDictArray[0].keys.first!)
        
        
        let graphView = ScrollableGraphView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2), dataSource: self)
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


        let referenceLines = ReferenceLines()
        referenceLines.relativePositions = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6,0.7, 0.8, 0.9, 1]

        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        referenceLines.dataPointLabelBottomMargin = 80

        let barPlot = BarPlot(identifier: "bar")
        //barPlot.shouldRoundBarCorners = true
        barPlot.barColor = .red


        let dotPlot = DotPlot(identifier: "dot")
        dotPlot.dataPointType = ScrollableGraphViewDataPointType.circle
        dotPlot.dataPointFillColor = .systemBlue
        dotPlot.dataPointSize = 4

        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        self.view.addSubview(graphView)

    }
    
    func makeNAScoreDictArray() -> [Dictionary<String, Int>]{
        let realm = try! Realm()
        let NAObjects = realm.objects(FeedBack.self).filter("style == 'NA'").sorted(byKeyPath: "date", ascending: false)
        var NAScoreDictArray = [Dictionary<String, Int>]()
        for NAobject in NAObjects{
            NAScoreDictArray.append([NAobject.date!:NAobject.score])
        }
        return NAScoreDictArray
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
                switch(plot.identifier) {
        case "line":
            return Double(NAScoreDictArray[pointIndex].values.first!)
        case "dot":
            return Double(NAScoreDictArray[pointIndex].values.first!)
        default:
            return 0
        }
    }

    func label(atIndex pointIndex: Int) -> String {
        let separated = NAScoreDictArray[pointIndex].keys.first!.components(separatedBy: "/")
        return separated[1] + separated[2]
    }

    func numberOfPoints() -> Int {
        return NAScoreDictArray.count
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
