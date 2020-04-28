//
//  AsianScoreCell.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/26.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift

class AsianScoreCell: UITableViewCell {
    
    var width = CGFloat()
    var height = CGFloat()
    var drawTotal = DrawScoreGraph(score:[0.0], date:[""])
    let AsianLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //プロットするデータ(スコア)
        var AsianPlotScore = [Double()]
        //プロットするデータ(日付)
        var AsianPlotDate = [String()]
        
        let realm = try! Realm()
        let AsianObjects = realm.objects(FeedBack.self).sorted(byKeyPath: "date").filter("style == 'Asian'").sorted(byKeyPath: "date")
        
        //DBを読んで配列にデータを追加
        for i in 0..<AsianObjects.count{
            AsianPlotScore.append(Double(AsianObjects[i].score))
            AsianPlotDate.append(AsianObjects[i].date.components(separatedBy: "年/")[1])
        }
        
        //一番最初に0が入ってしまうので削除
        AsianPlotScore.remove(at: 0)
        AsianPlotDate.remove(at: 0)
        
        let calc = ResultCalculation()
        let ave = calc.getAve(scoreList: AsianPlotScore)
        AsianLabel.text = "Asian 平均: \(ave)点"
        self.contentView.addSubview(AsianLabel)
        //グラフ描画インスタンス
        drawTotal = DrawScoreGraph(score:AsianPlotScore, date:AsianPlotDate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func callDrawMethod(){
        AsianLabel.frame = CGRect(x:width / 2, y: height * 0.75 , width: width / 2, height: height * 0.2)
        drawTotal.drawScoreGraph(cell: self, ViewWidth: width, ViewHeight: height * 0.8)
    }
    
}
