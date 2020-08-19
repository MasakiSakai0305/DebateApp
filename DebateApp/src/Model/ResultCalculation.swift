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
    
    //勝利・敗北数(トータル)
    var totalCount = 0.0
    var winCount = 0.0
    var loseCount = 0.0
    
    //スタイル
    var totalNACount = 0.0
    var NAWinCount = 0.0
    var NALoseCount = 0.0
    
    var totalBPCount = 0.0
    var BPWinCount = 0.0
    var BPLoseCount = 0.0

    var totalAsianCount = 0.0
    var AsianWinCount = 0.0
    var AsianLoseCount = 0.0
    
    //ロール
    var PMTotalCount = 0.0
    var PMWinCount = 0.0
    var PMLoseCount = 0.0
    
    var DPMTotalCount = 0.0
    var DPMWinCount = 0.0
    var DPMLoseCount = 0.0
    
    var MGTotalCount = 0.0
    var MGWinCount = 0.0
    var MGLoseCount = 0.0
    
    var GWTotalCount = 0.0
    var GWWinCount = 0.0
    var GWLoseCount = 0.0
    
    var PMRTotalCount = 0.0
    var PMRWinCount = 0.0
    var PMRLoseCount = 0.0
    
    var LOTotalCount = 0.0
    var LOWinCount = 0.0
    var LOLoseCount = 0.0
    
    var DLOTotalCount = 0.0
    var DLOWinCount = 0.0
    var DLOLoseCount = 0.0
    
    var MOTotalCount = 0.0
    var MOWinCount = 0.0
    var MOLoseCount = 0.0
    
    var OWTotalCount = 0.0
    var OWWinCount = 0.0
    var OWLoseCount = 0.0
    
    var LORTotalCount = 0.0
    var LORWinCount = 0.0
    var LORLoseCount = 0.0
    
    
    //勝率(トータル)
    var totalWinRate = Double()
    
    //スタイル
    var NAWinRate = Double()
    var BPWinRate = Double()
    var AsianWinRate = Double()
    
    //ロール
    var PMWinRate = Double()
    var DPMWinRate = Double()
    var MGWinRate = Double()
    var GWWinRate = Double()
    var PMRWinRate = Double()
    var LOWinRate = Double()
    var DLOWinRate = Double()
    var MOWinRate = Double()
    var OWWinRate = Double()
    var LORWinRate = Double()

    
    func resultCaluculationByStyle(){
        print("\n--resultCaluculation, 集計チェック(スタイル別)--")
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
                    print("obs[i].result==勝ちに関するエラー(スタイル)")
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
                    print("obs[i].result==負けに関するエラー(スタイル)")
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
        NAWinRate = Double(NAWinCount / totalNACount) * 100
        BPWinRate = Double(BPWinCount / totalBPCount) * 100
        AsianWinRate = Double(AsianWinCount / totalAsianCount) * 100
        print("AsianWinRate:", AsianWinRate)
    }
    
    
    func resultCaluculationByRole(){
        print("\n--resultCaluculation, 集計チェック(ロール別)--")
        let realm = try! Realm()
        let obs = realm.objects(FeedBack.self)
        print("obs.count:", obs.count)
        
        totalCount = Double(obs.count)
        
        for i in 0..<obs.count{
            if obs[i].result == "勝ち" {
                winCount += 1
                switch obs[i].role {
                case "PM":
                    PMWinCount += 1
                case "DPM":
                    DPMWinCount += 1
                case "MG":
                    MGWinCount += 1
                case "GW":
                    GWWinCount += 1
                case "PMR":
                    PMRWinCount += 1
                case "LO":
                    LOWinCount += 1
                case "DLO":
                    DLOWinCount += 1
                case "MO":
                    MOWinCount += 1
                case "OW":
                    OWWinCount += 1
                case "LOR":
                    LORWinCount += 1
                default:
                    print("obs[i].result==勝ちに関するエラー(ロール)")
                }
                
            }
            else if obs[i].result == "負け"{
                loseCount += 1
                
                switch obs[i].role {
                case "PM":
                    PMLoseCount += 1
                case "DPM":
                    DPMLoseCount += 1
                case "MG":
                    MGLoseCount += 1
                case "GW":
                    GWLoseCount += 1
                case "PMR":
                    PMRLoseCount += 1
                case "LO":
                    LOLoseCount += 1
                case "DLO":
                    DLOLoseCount += 1
                case "MO":
                    MOLoseCount += 1
                case "OW":
                    OWLoseCount += 1
                case "LOR":
                    LORLoseCount += 1
                default:
                    print("obs[i].result==勝ちに関するエラー(ロール)")
                }
            }
        }
        
        //勝利数・敗北数の集計
        PMTotalCount = PMWinCount + PMLoseCount
        DPMTotalCount = DPMWinCount + DPMLoseCount
        MGTotalCount = MGWinCount + MGLoseCount
        GWTotalCount = GWWinCount + GWLoseCount
        PMRTotalCount = PMRWinCount + PMRLoseCount
        LOTotalCount = LOWinCount + LOLoseCount
        DLOTotalCount = DLOWinCount + DLOLoseCount
        MOTotalCount = MOWinCount + MOLoseCount
        OWTotalCount = OWWinCount + OWLoseCount
        LORTotalCount = LORWinCount + LORLoseCount
        
        //勝率を計算
        totalWinRate = winCount / totalCount * 100
        PMWinRate = Double(PMWinCount / PMTotalCount) * 100
        DPMWinRate = Double(DPMWinCount / DPMTotalCount) * 100
        MGWinRate = Double(MGWinCount / MGTotalCount) * 100
        GWWinRate = Double(GWWinCount / GWTotalCount) * 100
        PMRWinRate = Double(PMRWinCount / PMRTotalCount) * 100
        LOWinRate = Double(LOWinCount / LOTotalCount) * 100
        DLOWinRate = Double(DLOWinCount / DLOTotalCount) * 100
        MOWinRate = Double(MOWinCount / MOTotalCount) * 100
        OWWinRate = Double(OWWinCount / OWTotalCount) * 100
        LORWinRate = Double(LORWinCount / LORTotalCount) * 100
    }
    
    //スコアの平均を取得
    func getAve(scoreList:[Double]) -> Double{
        var sum = Double()
        for score in scoreList{
            sum += score
        }
        return sum / Double(scoreList.count)
    }

}


class TagCalculation{
    
    var tagDict = Dictionary<String, Int>()
    var styleTagDict = Dictionary<String, Dictionary<String, Int> >()
    var roleTagDict = Dictionary<String, Dictionary<String, Int> >()
    var genreTagDict = Dictionary<String, Dictionary<String, Int> >()
//    var styleTagDict2 = ["NA": ["インパクトがない": 0, "イラストが足りない": 0, "モデルが分からない": 0, "irasutobusoku": 0, "aaa": 0], "BP": ["インパクトがない": 0, "イラストが足りない": 0, "モデルが分からない": 0, "irasutobusoku": 0, "aaa": 0], "Asian": ["インパクトがない": 0, "イラストが足りない": 0, "モデルが分からない": 0, "irasutobusoku": 0, "aaa": 0]]
    
    var tagString = [String]()
    
    func makeTagDictData(){
        let realm = try! Realm()
        let obs = realm.objects(TagList.self)
        print(obs)
        print(obs[0].tags)
        print("for tag")
        for tag in obs[0].tags{
            tagDict[tag["tag"] as! String] = 0
        }
//        print(tagDict)
    }
    
    func makeStyleTagData(){
        print(tagDict)
        for style in FeedBackItemList().styleList{
            styleTagDict[style] = tagDict
        }
        print(styleTagDict)
    }
    
    func makeRoleTagData(){
        for role in FeedBackItemList().roleList{
            roleTagDict[role] = tagDict
        }
//        print(roleTagDict)
    }
    
    func makeGenreTagData(){
        for genre in FeedBackItemList().motionGenreList{
            genreTagDict[genre] = tagDict
        }
//        print(genreTagDict)
    }
    
    func addTag(){
        let realm = try! Realm()
        let obs = realm.objects(FeedBack.self)
    
        //DBのデータを１つずつ参照
        for object in obs{
            print("--object--\n", object)
            //そのデータが保持しているタグを1つずつ参照して加算する
            for tag in object.tags{
                print(tag["tag"]!)
                print(styleTagDict[object.style]![tag["tag"] as! String]!)
                //「スタイル」のカテゴリでタグを加算する
                styleTagDict[object.style]![tag["tag"] as! String]! += 1
                //「ロール」のカテゴリでタグを加算する
                roleTagDict[object.role]![tag["tag"] as! String]! += 1
                //「モーションジャンル」のカテゴリでタグを加算する
                genreTagDict[object.motionGenre]![tag["tag"] as! String]! += 1
            }
        }
        print(styleTagDict)
        print(roleTagDict)
        print(genreTagDict)
    }
}


