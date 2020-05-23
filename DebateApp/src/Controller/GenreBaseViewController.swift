//
//  GenreBaseViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/23.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import SegementSlide

class GenreBaseViewController: SegementSlideDefaultViewController {

 override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        reloadData()
        defaultSelectedIndex = 0
        
       
        
    }
    
//    override var switcherConfig: SegementSlideDefaultSwitcherConfig {
//        var config = super.switcherConfig
//        config.type = .tab
//        config.horizontalMargin = 30
//        return config
//    }
    
    
    override var titlesInSwitcher: [String]{
        return ["Animal", "Art", "CJS", "Children", "Choice", "Corporation", "Development", "Economy", "Education", "Environment", "Expression", "Feminism", "Gender", "IR", "LGBTQIA", "Labor Rights", "Medical", "Narrative", "Politics", "Poverty", "Religion", "Social Movement", "Others"]
    }
    

    
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        
        switch index {
            
        case 0:
            return StyleViewController()
        case 1:
            return RoleViewController()
        default:
            return StyleViewController()
        }
    }

}
