//
//  SHCImageCollectionViewCell.swift
//  PhotoPicker
//
//  Created by 邵焕超 on 2018/5/28.
//  Copyright © 2018年 邵焕超. All rights reserved.
//

import UIKit

class SHCImageCollectionViewCell: UICollectionViewCell {
  
  var  isDisabled: Bool = false {
    didSet{
      grayView.isHidden = (isDisabled && !isSelected) ? false : true
    }
  }
  
  override var isSelected: Bool {
    didSet {
      let str = isSelected ? "btn_check_selected_40" : "btn_check_normal_40"
      iconView.image = UIImage(named: str, selfClass: SHCImageCollectionViewCell.self)
      
      if !isSelected || isDisabled { return }
      UIView.animate(withDuration: 0.1, animations: {
        self.iconView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      }) { (Bool) in
        UIView.animate(withDuration: 0.2, animations: {
          self.iconView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
      }
    }
  }
  
  
  let imageView = UIImageView()
  let iconView  = UIImageView()
  private let grayView  = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SHCImageCollectionViewCell {
  fileprivate func buildUI() {
    contentView.addSubview(imageView)
    contentView.addSubview(iconView)
    contentView.addSubview(grayView)
    
    iconView.image = UIImage(named: "btn_check_normal_40",
                             selfClass: SHCImageCollectionViewCell.self)
    
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    
    grayView.isHidden = true
    grayView.backgroundColor = UIColor.gray
    grayView.alpha = 0.5
    
    imageView.frame = self.bounds
    grayView.frame = self.bounds
    iconView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(2)
      make.right.equalToSuperview().offset(-2)
      make.width.height.equalTo(23)
    }
    
  }
}

