//
//  BPPieChartViewCell.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/21.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import Charts


//円グラフ(BPの勝率)を描画
class BPPieChartViewCell: UITableViewCell {

    @IBOutlet weak var pieChartView: PieChartView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
            let drawGraph = DrawGraph()
            drawGraph.setPieGraph(filter:"BP", chartView:pieChartView, cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
