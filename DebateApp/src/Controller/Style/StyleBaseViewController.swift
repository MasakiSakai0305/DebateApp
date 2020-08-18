//
//  BaseViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/22.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import SegementSlide
import RealmSwift

class StyleBaseViewController: SegementSlideDefaultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        reloadData()
        defaultSelectedIndex = 0
        
        print("push style4")
        
        let realm = try! Realm()
        let TotalObjects = realm.objects(FeedBack.self).sorted(byKeyPath: "date")
        let NAObjects = realm.objects(FeedBack.self).filter("style == 'NA'").sorted(byKeyPath: "date", ascending: false)
        let BPObjects = realm.objects(FeedBack.self).filter("style == 'BP'").sorted(byKeyPath: "date", ascending: false)
        let AsianObjects = realm.objects(FeedBack.self).filter("style == 'Asian'").sorted(byKeyPath: "date", ascending: false)
        
       
        
    }
    
    func makeNAScoreDict(){
        let realm = try! Realm()
    }
    
    override var switcherConfig: SegementSlideDefaultSwitcherConfig {
        var config = super.switcherConfig
        config.type = .tab
        config.horizontalMargin = 30
        return config
    }
    
    
    override var titlesInSwitcher: [String]{
        return ["NA", "BP", "Asian"]
    }
    

    
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        
        switch index {
            
        case 0:
            return NASlideController()
        case 1:
            return BPSlideController()
        case 2:
            return AsianSlideController()
        default:
            return NASlideController()
        }
    }
}
