//
//  PMPieChartViewCell.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/08/19.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import Charts

class PMPieChartViewCell: UITableViewCell {
    
    var resultLabel = UILabel()
    @IBOutlet weak var PMPieChartView: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let drawGraph = DrawGraph()
        drawGraph.setPieGraph(filter:"PM", chartView:PMPieChartView, cell: self)
        self.contentView.addSubview(resultLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
