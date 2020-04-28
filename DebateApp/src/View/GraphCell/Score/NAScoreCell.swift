//
//  NAScoreCell.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/26.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift

class NAScoreCell: UITableViewCell {
    
    var width = CGFloat()
    var height = CGFloat()
    var drawTotal = DrawScoreGraph(score:[0.0], date:[""])
    let NALabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //プロットするデータ(スコア)
        var NAPlotScore = [Double()]
        //プロットするデータ(日付)
        var NAPlotDate = [String()]
        
        let realm = try! Realm()
        let NAObjects = realm.objects(FeedBack.self).sorted(byKeyPath: "date").filter("style == 'NA'").sorted(byKeyPath: "date")
        
        print("NAObjects")
        print(NAObjects)
        //DBを読んで配列にデータを追加
        for i in 0..<NAObjects.count{
            NAPlotScore.append(Double(NAObjects[i].score))
            NAPlotDate.append(NAObjects[i].date.components(separatedBy: "年/")[1])
        }
        
        //一番最初に0が入ってしまうので削除
        NAPlotScore.remove(at: 0)
        NAPlotDate.remove(at: 0)
        
        let calc = ResultCalculation()
        let ave = calc.getAve(scoreList: NAPlotScore)
        NALabel.text = "NA 平均: \(ave)点"
        self.contentView.addSubview(NALabel)
        
        //グラフ描画インスタンス
        drawTotal = DrawScoreGraph(score:NAPlotScore, date:NAPlotDate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func callDrawMethod(){
        NALabel.frame = CGRect(x:width / 2, y: height * 0.8 , width: width / 2, height: height * 0.2)
        drawTotal.drawScoreGraph(cell: self, ViewWidth: width, ViewHeight: height * 0.8)
    }
}
