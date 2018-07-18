//
//  SHCEmpyView.swift
//  Kingfisher
//
//  Created by 邵焕超 on 2018/7/13.
//

import UIKit

class SHCEmpyView: UIView {
  
  let title = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    title.text = "请在iPhone的“设置-隐私-照片”选项中，允许膳小二访问你的手机相册。"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
