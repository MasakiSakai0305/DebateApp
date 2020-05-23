//
//  BaseViewController.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/22.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit
import SegementSlide

class StyleBaseViewController: SegementSlideDefaultViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        reloadData()
        defaultSelectedIndex = 0
        
       
        
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
            return StyleViewController()
        case 1:
            return RoleViewController()
        default:
            return StyleViewController()
        }
    }
}
