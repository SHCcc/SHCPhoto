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
  
  var maxSelected = 4 {
    didSet{ titleLabel.text = "0/\(maxSelected)" }
  }
  
  var imageCount = 0 {
    didSet{
      isUserInteractionEnabled = imageCount != 0
      titleLabel.text = "\(imageCount)/\(maxSelected)"
    }
  }
  
  private let completeBtn = UIButton()
  
  private let titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    /// 响应更改 互换 deleteBtn <=> self
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
    addSubview(completeBtn)
    addSubview(titleLabel)
    buildSubView()
    buildLayout()
  }
  
  private func buildSubView() {
    completeBtn.setTitle("完成", for: .normal)
    completeBtn.backgroundColor = UIColor.blue
    completeBtn.layer.cornerRadius = 5
    completeBtn.layer.masksToBounds = true
    completeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    
    titleLabel.text = "0/4"
  }
  
  private func buildLayout() {
    completeBtn.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.right.equalToSuperview().offset(-15)
      make.height.equalTo(30)
      make.width.equalTo(60)
    }
    titleLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.right.equalTo(completeBtn.snp.left).offset(-10)
    }
  }
}
