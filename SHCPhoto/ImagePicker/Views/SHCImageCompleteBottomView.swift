//
//  SHCImageCompleteBottomView.swift
//  PhotoPicker
//
//  Created by 邵焕超 on 2018/5/29.
//  Copyright © 2018年 邵焕超. All rights reserved.
//

import UIKit
import SnapKit

class SHCImageCompleteBottomView: UIView {
  private let btnColor1 = UIColor(red: 74/255, green: 161/255, blue: 23/255, alpha: 1)
  private let btnColor2 = UIColor(red: 31/255, green: 67/255, blue: 19/255, alpha: 1)
  private let backColor = UIColor(red: 29/255, green: 33/255, blue: 40/255, alpha: 1)
  
  var imageCount = 0 {
    didSet{
      isUserInteractionEnabled = imageCount != 0
      let countStr = imageCount > 0 ? "(\(imageCount))" : ""
      completeBtn.setTitle("完成\(countStr)", for: .normal)
      completeBtn.backgroundColor = imageCount != 0 ? btnColor1 : btnColor2
    }
  }
  
  private let completeBtn = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    /// 响应更改 互换 Btn <=> self
    let newP = self.convert(point, to: self)
    if self.point(inside: newP, with: event) {
      let newP2 = self.convert(newP, to: self.completeBtn)
      if completeBtn.point(inside: newP2, with: event) {
        return self
      }
      return nil
    }
    return super.hitTest(point, with: event)
  }
}

extension SHCImageCompleteBottomView{
  fileprivate func buildUI() {
    isUserInteractionEnabled = false
    backgroundColor = backColor
    
    addSubview(completeBtn)
    
    buildSubView()
    buildLayout()
  }
  
  private func buildSubView() {
    completeBtn.setTitle("完成", for: .normal)
    completeBtn.backgroundColor = btnColor2
    
    completeBtn.layer.cornerRadius = 5
    completeBtn.layer.masksToBounds = true
    completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
  }
  
  private func buildLayout() {
    completeBtn.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.right.equalToSuperview().offset(-15)
      make.height.equalTo(30)
      make.width.equalTo(60)
    }
  }
}
