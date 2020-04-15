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



        
    }
    
    //耐久チェック(どれくらい作って問題ないのか)
    @IBAction func makeManyData(_ sender: Any) {
        print("--makeManyData--")
        let realm = try! Realm()
        let max = 300
        
        for i in 0..<max{
            let fb = FeedBack()
            fb.MotionTitle = "test\(i)"
            fb.FeedBackString = "test\(i)"
            fb.result = "勝ち"
            fb.score = 65
            fb.style = "N"
            fb.date = "1"
            
            // DBに書き込む
            try! realm.write {
                realm.add(fb)
            }
        }
        
        print("\(max)個のデータ作成完了")
        let obs = realm.objects(FeedBack.self)
        print(obs[50])
        print(obs[99])
        
        
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
