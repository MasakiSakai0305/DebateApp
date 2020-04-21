//
//  ResultCalculation.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/16.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import Foundation
import RealmSwift

class ResultCalculation{
    
    //集計
    var totalCount = 0.0
    var winCount = 0.0
    var loseCount = 0.0
    
    var totalNACount = 0.0
    var NAWinCount = 0.0
    var NALoseCount = 0.0
    
    var totalBPCount = 0.0
    var BPWinCount = 0.0
    var BPLoseCount = 0.0
    
    var totalAsianCount = 0.0
    var AsianWinCount = 0.0
    var AsianLoseCount = 0.0
    
    //勝率
    var totalWinRate = Double()
    var NAWinRate = Double()
    var BPWinRate = Double()
    var AsianWinRate = Double()

    func resultCaluculation(){
        print("\n--resultCaluculation, 集計チェック--")
        let realm = try! Realm()
        let obs = realm.objects(FeedBack.self)
        print("obs.count:", obs.count)
        
        totalCount = Double(obs.count)
        
        for i in 0..<obs.count{
            if obs[i].result == "勝ち" {
                winCount += 1
                switch obs[i].style {
                case "NA":
                    NAWinCount += 1
                case "BP":
                    BPWinCount += 1
                case "Asian":
                    AsianWinCount += 1
                default:
                    print("obs[i].result==勝ちに関するエラー")
                }
                
            }
            else if obs[i].result == "負け"{
                loseCount += 1
                
                switch obs[i].style {
                case "NA":
                    NALoseCount += 1
                case "BP":
                    BPLoseCount += 1
                case "Asian":
                    AsianLoseCount += 1
                default:
                    print("obs[i].result==負けに関するエラー")
                }
            }
        }
        
        totalNACount = NAWinCount + NALoseCount
        totalBPCount = BPWinCount + BPLoseCount
        totalAsianCount = AsianWinCount + AsianLoseCount
        
        print("total:", totalCount, ", win:", winCount, ", lose:", loseCount)
        print("NATotal:", totalNACount, ", win:", NAWinCount, ", lose:", NALoseCount)
        print("BPTotal:", totalBPCount, ", win:", BPWinCount, ", lose:", BPLoseCount)
        print("AsianTotal:", totalAsianCount, ", win:", AsianWinCount, ", lose:", AsianLoseCount)
        
        
        totalWinRate = winCount / totalCount * 100
        print("totalWinRate:", totalWinRate)
        NAWinRate = Double(totalNACount / NAWinCount) * 100
        BPWinRate = Double(totalBPCount / BPWinCount) * 100
        AsianWinRate = Double(totalAsianCount / AsianWinCount) * 100
        print("AsianWinRate:", AsianWinRate)
    }

}
