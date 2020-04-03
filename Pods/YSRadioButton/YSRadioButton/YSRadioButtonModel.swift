//
//  YSRadioButtonModel.swift
//  Demo
//
//  Created by 関　洋輔 on 2019/09/17.
//  Copyright © 2019 関　洋輔. All rights reserved.
//

import Foundation

protocol YSRadioButtonModelDelegate {
    func ysRadioButtonModelDidSet(no:Int?)
}

class YSRadioButtonModel {
    var delegate:YSRadioButtonModelDelegate?
    var selectedNo:Int? {
        didSet{
            delegate?.ysRadioButtonModelDidSet(no: selectedNo)
        }
    }
 
    func set(no:Int){
        selectedNo = no
    }
}
