//
//  SHCImagePickerCell.swift
//  testPhoto
//
//  Created by 邵焕超 on 2018/5/28.
//  Copyright © 2018年 邵焕超. All rights reserved.
//

import UIKit
import SnapKit

class SHCImagePickerCell: UITableViewCell {
  
  var titleLabel = UILabel()
  var countLabel = UILabel()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UI
extension SHCImagePickerCell {
  fileprivate func buildUI() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(countLabel)
    
    buildSubView()
    buildLayout()
  }
  
  private func buildSubView() {
    
  }
  
  private func buildLayout() {
    titleLabel.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().offset(15)
    }
    countLabel.snp.makeConstraints { (make) in
      make.left.equalTo(titleLabel.snp.right).offset(15)
      make.centerY.equalTo(titleLabel)
    }
  }
}

