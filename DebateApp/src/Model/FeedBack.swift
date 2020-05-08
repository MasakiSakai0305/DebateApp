//
//  FeedBack.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/03.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import Foundation
import RealmSwift


class FeedBack:Object{
    
    //モーション名
    @objc dynamic var MotionTitle:String!
    //勝ち負け
    @objc dynamic var result:String!
    //スコア
    @objc dynamic var score = 0
    //ラウンドのスタイル
    @objc dynamic var style:String!
    //フィードバック
    @objc dynamic var FeedBackString:String!
    //タイムスタンプ
    @objc dynamic var date:String!
    //モーションジャンル
    @objc dynamic var motionGenre:String!
    //サイド
    @objc dynamic var side:String!
    //ロール
    @objc dynamic var role:String!
    //タグリスト
    let tags = List<Tag>()
    
    @objc dynamic var a:String!
    
}

class Tag:Object{
    //タグ
    @objc dynamic var tag:String!
}

class TagList:Object{}


class FeedBackItemList{
    
    let WLList = ["勝ち", "負け"]
    let styleList = ["NA", "BP", "Asian"]
    var scoreList = ["65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82","83", "84", "85"]
    let yearList = ["2020年", "2021年", "2022年", "2023年", "2024年", "2025年", "2026年", "2027年", "2028年", "2029年"]
    let monthList = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"]
    let dayList = ["1日", "2日", "3日", "4日", "5日", "6日", "7日", "8日", "9日", "10日", "11日", "12日", "13日", "14日", "15日", "16日", "17日", "18日", "19日", "20日", "21日", "22日", "23日", "24日", "25日", "26日", "27日", "28日", "29日", "30日", "31日"]
    
    let motionGenreList = ["Animal", "Art", "CJS", "Children", "Choice", "Corporation", "Development", "Economy", "Education", "Environment", "Expression", "Feminism", "Gender", "IR", "LGBTQIA", "Labor Rights", "Medical", "Narrative", "Politics", "Poverty", "Religion", "Social Movement", "Others"]

    let sideList = ["Gov", "Opp", "OG", "OO", "CG", "CO"]
    let roleList = ["PM", "DPM", "MG", "GW", "GR", "LO", "DLO", "MO", "OW", "OR"]
    
}
