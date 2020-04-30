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
    
}
