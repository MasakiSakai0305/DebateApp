//
//  BarChartwCell.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/17.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import Charts

class BarChartwCell: UITableViewCell {

    
    
    @IBOutlet weak var barChartView: BarChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awakeFromNib2")
        
        setBarGragh()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBarGragh(){
        let rawData: [Int] = [20, 50, 70, 30, 60, 1000, 40, 40,40,40,40,40,40,40,40,40,40,40,40,40]
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data

        
    }
}
