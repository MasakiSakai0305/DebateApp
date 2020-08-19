//
//  BPScoreCell.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/26.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift

class BPScoreCell: UITableViewCell {
    
    var width = CGFloat()
    var height = CGFloat()
    var drawTotal = DrawScoreGraph(score:[0.0], date:[""])
    let BPLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //プロットするデータ(スコア)
        var BPPlotScore = [Double()]
        //プロットするデータ(日付)
        var BPPlotDate = [String()]
        
        let realm = try! Realm()
        let BPObjects = realm.objects(FeedBack.self).sorted(byKeyPath: "date").filter("style == 'BP'").sorted(byKeyPath: "date")
        
        //DBを読んで配列にデータを追加
        for i in 0..<BPObjects.count{
            BPPlotScore.append(Double(BPObjects[i].score))
            BPPlotDate.append(BPObjects[i].date.components(separatedBy: "年/")[1])
        }
        
        //一番最初に0が入ってしまうので削除
        BPPlotScore.remove(at: 0)
        BPPlotDate.remove(at: 0)
        
        let calc = ResultCalculation()
        let ave = calc.getAve(scoreList: BPPlotScore)
        BPLabel.text = "BP 平均: \(ave)点"
        self.contentView.addSubview(BPLabel)
        
        //グラフ描画インスタンス
        drawTotal = DrawScoreGraph(score:BPPlotScore, date:BPPlotDate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func callDrawMethod(){
        BPLabel.frame = CGRect(x:width / 2, y: height * 0.8 , width: width / 2, height: height * 0.2)
        drawTotal.drawScoreGraph(cell: self, ViewWidth: width, ViewHeight: height * 0.8)
    }
    
}
