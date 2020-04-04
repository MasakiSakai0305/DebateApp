//
//  ExViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/04/04.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import RealmSwift

class ExViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let realm = try! Realm()
        let obs = realm.objects(FeedBack.self)
        for ob in obs{
            print(ob.MotionTitle)
            print(ob)
        }
        
        print("--search--")
        let results = realm.objects(FeedBack.self).filter("score == 65")
        print(results)
        
//        print("--delete--")
//        try! realm.write {
//            realm.delete(results[0])
//        }
//        print(realm.objects(FeedBack.self))


        
        
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
