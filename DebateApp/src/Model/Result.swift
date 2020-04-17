//
//  Result.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/16.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//




/*結論: グラフを表示する際にその都度集計しても問題なさそう, オブジェクトを作る必要がなさそうなので必要なくなった
 けど, 何が起こるか分からないから, 一応残しておく
*/

import Foundation
import RealmSwift

//トータルの戦績
class TotalResult:Object{
    
    @objc dynamic var totalCount = 0
    @objc dynamic var winCount = 0
    @objc dynamic var loseCount = 0

}

//スタイルごとの戦績
class styleResult:Object{
    
    //NAの戦績
    @objc dynamic var NAtotalCount = Int()
    @objc dynamic var NAwinCount = Int()
    @objc dynamic var NAloseCount = Int()
    
    //BPの戦績
    @objc dynamic var BPtotalCount = Int()
    @objc dynamic var BPwinCount = Int()
    @objc dynamic var BPloseCount = Int()
    
    //Asianの戦績
    @objc dynamic var AsiantotalCount = Int()
    @objc dynamic var AsianwinCount = Int()
    @objc dynamic var AsianloseCount = Int()
}
