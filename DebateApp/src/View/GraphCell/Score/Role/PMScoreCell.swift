//
//  PMScoreCell.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/08/19.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift

class PMScoreCell: UITableViewCell {
    
    var width = CGFloat()
    var height = CGFloat()
    var drawTotal = DrawScoreGraph(score:[0.0], date:[""])
    let PMLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //プロットするデータ(スコア)
        var PMPlotScore = [Double()]
        //プロットするデータ(日付)
        var PMPlotDate = [String()]
        
        let realm = try! Realm()
        let PMObjects = realm.objects(FeedBack.self).sorted(byKeyPath: "date").filter("role == 'PM'").sorted(byKeyPath: "date")
        
        print("PMObjects")
        print(PMObjects)
        //DBを読んで配列にデータを追加
        for i in 0..<PMObjects.count{
            PMPlotScore.append(Double(PMObjects[i].score))
            PMPlotDate.append(PMObjects[i].date.components(separatedBy: "年/")[1])
        }
        
        //一番最初に0が入ってしまうので削除
        PMPlotScore.remove(at: 0)
        PMPlotDate.remove(at: 0)
        
        let calc = ResultCalculation()
        let ave = calc.getAve(scoreList: PMPlotScore)
        PMLabel.text = "PM 平均: \(ave)点"
        self.contentView.addSubview(PMLabel)
        
        //グラフ描画インスタンス
        drawTotal = DrawScoreGraph(score:PMPlotScore, date:PMPlotDate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func callDrawMethod(){
        PMLabel.frame = CGRect(x:width / 2, y: height * 0.8 , width: width / 2, height: height * 0.2)
        drawTotal.drawScoreGraph(cell: self, ViewWidth: width, ViewHeight: height * 0.8)
    }
    
}
