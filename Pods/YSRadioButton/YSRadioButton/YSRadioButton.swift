//
//  YSRadioButton.swift
//  YSRadioButton
//
//  Created by 関　洋輔 on 2019/09/02.
//  Copyright © 2019 関　洋輔. All rights reserved.
//

import UIKit

class YSRadioButton: UIButton {
    var margin:CGFloat = 5
    var fillSize:CGFloat = 0.6
    var lineWidth:CGFloat = 1.0
    var strokeColor:UIColor = UIColor.init(
        red: 112.0/255.0,
        green: 112.0/255.0,
        blue: 112.0/255.0,
        alpha: 1
    )
    var fillColor:UIColor = UIColor.init(
        red: 87.0/255.0,
        green: 203.0/255.0,
        blue: 149.0/255.0,
        alpha: 1
    )
    private let fillLayer = CAShapeLayer()
    
    /// ラジオボタンを生成
    func drawCircle() {
        let size:CGFloat = circleSize()
        let circle = UIBezierPath(
            arcCenter: CGPoint(x: size, y: margin+size),
            radius: size,
            startAngle: 0,
            endAngle: CGFloat(Double.pi)*2,
            clockwise: true
        )
        let edgeLayer = CAShapeLayer()
        edgeLayer.path = circle.cgPath
        edgeLayer.lineWidth = lineWidth
        edgeLayer.strokeColor = strokeColor.cgColor
        edgeLayer.fillColor = UIColor.clear.cgColor
        self.layer.insertSublayer(edgeLayer, at: 0)
        makeFillLayer()
    }

    
    /// ラジオボタンの塗り部分のレイヤーの生成
    private func makeFillLayer(){
        fillLayer.lineWidth = 0.0
        fillLayer.strokeColor = UIColor.clear.cgColor
        fillLayer.fillColor = fillColor.cgColor
        self.layer.insertSublayer(fillLayer, at: 0)
    }
    
    /// ラジオボタンの円サイズの生成
    ///
    /// - Returns: 高さからマージンを引いた半径を返す
    private func circleSize() -> CGFloat{
        return (self.frame.size.height-margin*2)*0.5
    }
    
    /// ラジオボタンを選択状態にする
    func drawSelectedCircle() {
        let minPath = fillMinPath()
        let maxPath = fillMaxPath()
        fillLayer.path = minPath.cgPath
        let anim = makeAnim(fromPath: fillLayer.path!,toPath: maxPath.cgPath)
        fillLayer.add(anim, forKey: anim.keyPath)
    }
    
    /// ラジオボタンを非選択状態にする
    func clearSelectedCircle() {
        let minPath = fillMinPath()
        let maxPath = fillMaxPath()
        fillLayer.path = maxPath.cgPath
        let anim = makeAnim(fromPath: fillLayer.path!,toPath: minPath.cgPath)
        fillLayer.add(anim, forKey: anim.keyPath)
    }
    
    /// パスのアニメーション
    ///
    /// - Parameters:
    ///   - fromPath: アニメーション開始時のパス
    ///   - toPath: アニメーション終了時のパス
    /// - Returns: 生成されたアニメーション
    private func makeAnim(fromPath:CGPath,toPath:CGPath) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = 0.25
        animation.fromValue = fromPath
        animation.toValue = toPath
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fillMode = CAMediaTimingFillMode.both
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    /// ラジオボタンの選択状態のpath
    ///
    /// - Returns: 指定サイズ半径のUIBezierPathを返す
    private func fillMaxPath() -> UIBezierPath{
        let rect = self.frame
        let size = circleSize()*fillSize
        let center:CGFloat = (rect.size.height-margin*2)*0.5
        return UIBezierPath(
            arcCenter: CGPoint(x: center, y: margin+center),
            radius: size,
            startAngle: 0,
            endAngle: CGFloat(Double.pi)*2,
            clockwise: true
        )
    }
    
    
    /// ラジオボタンの非選択状態のpath
    ///
    /// - Returns: 半径0のUIBezierPathを返す
    private func fillMinPath() -> UIBezierPath{
        let rect = self.frame
        let center:CGFloat = (rect.size.height-margin*2)*0.5
        return UIBezierPath(
            arcCenter: CGPoint(x: center, y: margin+center),
            radius: 0,
            startAngle: 0.0,
            endAngle: CGFloat(Double.pi)*2,
            clockwise: true
        )
    }
}
