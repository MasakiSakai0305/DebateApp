//
//  ExViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/04.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift

//Realm試し用
class ExViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let realm = try! Realm()
        let obs = realm.objects(FeedBack.self)
        
        if obs.count > 0{
            for ob in obs{
                print(ob.MotionTitle)
                print(ob)
            }
            
            print("--search--")
            let results = realm.objects(FeedBack.self).filter("score == 65")
            print(results)
            
            print("--update--")
            try! realm.write({
                obs[0].MotionTitle = "THW ban tabacco"
            })
            
            print(obs)
            label.text = obs[0].MotionTitle
        }
//        print("--delete--")
//        try! realm.write {
//            realm.delete(results[0])
//        }
//        print(realm.objects(FeedBack.self))
        
        
        
        // 空オブジェクトを書き込み
        try! realm.write {
            realm.add(TotalResult())
        }



        
    }
    
    //耐久チェック(どれくらい作って問題ないのか)
    @IBAction func makeManyData(_ sender: Any) {
        print("--makeManyData--")
        let realm = try! Realm()
        let max = 5
        
        for i in 0..<max{
            let fb = FeedBack()
            
            fb.MotionTitle = "test\(i)"
            fb.FeedBackString = "test\(i)"
            fb.result = "勝ち"
            fb.score = 65
            fb.style = "NA"
            fb.date = "\(Int.random(in: 0..<10))"
            
            if i % 2 == 0{
                fb.result = "負け"
            }
            
            // DBに書き込む
            try! realm.write {
                realm.add(fb)
            }
            
            //saveTotalResult(result: fb.result, realmObj: realm)
        }
        
        print("\(max)個のデータ作成完了")
        let obs = realm.objects(FeedBack.self)
        print(obs)
        sortDate()
        
        
//        print(obs[50])
//        print(obs[99])
        
        //成功しているか確認
//        print("--check--")
//        let objects = realm.objects(TotalResult.self)
//        print(objects)
        
        //集計
        var total = obs.count
        var win = 0
        var lose = 0
        
        for i in 0..<obs.count{
            if obs[i].result == "勝ち" {
                win += 1
            }
            else if obs[i].result == "負け"{
                lose += 1
            }
        }
        
        print("total:", total, ", win:", win, ", lose:", lose)
        
        
    }
    
    
    //ソート機能試し
    func sortDate(){
        print("--sortDate--")
        let realm = try! Realm()
        var objects = realm.objects(FeedBack.self)
        let sorted = objects.sorted(byKeyPath: "date")
        print(sorted)
        
        //データ更新
        try! realm.write({
            objects = sorted
        })
        
        print("objects\n--", objects)
        
    }
    
    
    func saveTotalResult(result:String, realmObj:Realm){
       // let totalResult = TotalResult()
        let object = realmObj.objects(TotalResult.self)[0]
        
        //書き込み
        try! realmObj.write({
            object.totalCount += 1
            if result == "勝ち"{
                object.winCount += 1
            } else if result == "負け"{
                object.loseCount += 1
            }
          })
        

    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
