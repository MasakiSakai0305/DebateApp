//
//  YSRadioButtonViewController.swift
//  YSRadioButton
//
//  Created by 関　洋輔 on 2019/09/02.
//  Copyright © 2019 関　洋輔. All rights reserved.
//

import UIKit

public protocol YSRadioButtonViewControllerDelegate {
    func didYSRadioButtonSelect(no:Int)
}


public class YSRadioButtonViewController: UIViewController,YSRadioButtonModelDelegate {
    private var selectedBtn:YSRadioButton?
    private var radioGroupView:YSRadioButtonGroupView = YSRadioButtonGroupView()
    
    public var delegate:YSRadioButtonViewControllerDelegate?
    
    public var labelColor: UIColor {
        get { return radioGroupView.labelColor }
        set { radioGroupView.labelColor = newValue }
    }
    
    public var font: UIFont {
        get { return radioGroupView.font }
        set { radioGroupView.font = newValue }
    }
    
    public var radioHeadFill: UIColor {
        get { return radioGroupView.radioHeadFill }
        set { radioGroupView.radioHeadFill = newValue }
    }
    
    public var radioHeadStroke: UIColor {
        get { return radioGroupView.radioHeadStroke }
        set { radioGroupView.radioHeadStroke = newValue }
    }
    
    public var radioHeadFillSize: CGFloat {
        get { return radioGroupView.radioHeadFillSize }
        set { radioGroupView.radioHeadFillSize = newValue }
    }
    
    public var radioHeadMargin: CGFloat {
        get { return radioGroupView.radioHeadMargin }
        set { radioGroupView.radioHeadMargin = newValue }
    }
    
    public var labelMargin: CGFloat {
        get { return radioGroupView.labelMargin }
        set { radioGroupView.labelMargin = newValue }
    }

    public var lineWidth: CGFloat {
        get { return radioGroupView.lineWidth }
        set { radioGroupView.lineWidth = newValue }
    }

    private var model:YSRadioButtonModel = YSRadioButtonModel()

    
    public init(labels: [String]) {
        super.init(nibName: nil, bundle: nil)
        radioGroupView.btnLabels = labels
        model.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        self.view = radioGroupView
        radioGroupView.layoutButtons()
        for (i, btn) in radioGroupView.btns.enumerated() {
            btn.tag = i
            btn.addTarget(self, action: #selector(btnTapped(_:)), for: .touchUpInside)
        }

    }

    
    @objc func btnTapped(_ sender: YSRadioButton) {
        if let sb = selectedBtn{
            sb.clearSelectedCircle()
        }
        sender.drawSelectedCircle()
        selectedBtn = sender
        model.set(no: sender.tag)
    }
    
    func ysRadioButtonModelDidSet(no: Int?) {
        delegate?.didYSRadioButtonSelect(no: no!)
    }
}
