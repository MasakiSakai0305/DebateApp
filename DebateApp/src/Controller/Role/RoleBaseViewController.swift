//
//  RoleBaseViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/23.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import SegementSlide

class RoleBaseViewController: SegementSlideDefaultViewController {

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
        return ["PM", "DPM", "MG", "GW", "PMR", "LO", "DLO", "MO", "OW", "LOR"]
    }
    

    
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        
        switch index {
            
        case 0:
            return PMSlideController()
        case 1:
            return DPMSlideController()
        case 2:
            return MGSlideController()
        case 3:
            return GWSlideController()
        case 4:
            return PMRSlideController()
        case 5:
            return LOSlideController()
        case 6:
            return DLOSlideController()
        case 7:
            return MOSlideController()
        case 8:
            return OWSlideController()
        case 9:
            return LORSlideController()
        default:
            return PMSlideController()
        }
    }

}
