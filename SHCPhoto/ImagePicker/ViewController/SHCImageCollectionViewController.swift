//
//  SHCImageCollectionViewController.swift
//  PhotoPicker
//
//  Created by 邵焕超 on 2018/5/28.
//  Copyright © 2018年 邵焕超. All rights reserved.
//

import UIKit
import Photos
import SHCHUD

class SHCImageCollectionViewController: UIViewController {
  
  // 图片资源
  var assetsFetchResults: PHFetchResult<PHAsset>?
  
  // 图片缓存管理
  var imageManager = PHCachingImageManager()
  let option = PHImageRequestOptions()

  // 缩略图size
  var assetGridThumbnailSize: CGSize!

  // 最大选择数量
  var maxSelected = 4 
  
  //照片选择完毕后的回调
  var completeHandler:((_ images: [UIImage]?)->())?
  
  private var completeBtnlock = false
  
  private let layout = UICollectionViewFlowLayout()
  
  private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
  
  private var bottomView = SHCImageCompleteBottomView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    buildUI()
    
    //重置缓存
    resetCachedAssets()
  }
}

// MARK: - UI
extension SHCImageCollectionViewController {
  fileprivate func buildUI() {
    view.addSubview(collectionView)
    view.addSubview(bottomView)

    automaticallyAdjustsScrollViewInsets = false

    view.backgroundColor = UIColor.white
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(cancel))
    
    buildSubView()
    buildLayout()
  }
  
  private func buildSubView() {
    layout.minimumInteritemSpacing = 1
    layout.minimumLineSpacing = 1
    let width = UIScreen.main.bounds.width / 4 - 1
    layout.itemSize = CGSize(width: width,
                             height: width)
    
    let scale = UIScreen.main.scale + 3
    assetGridThumbnailSize = CGSize(width: width * scale,
                                    height: width * scale)
//    collectionView.contentSize = CGSize(width: 0, height: 1000)
//    collectionView.bounces = true
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.allowsMultipleSelection = true
    collectionView.backgroundColor = UIColor.white
    collectionView.register(SHCImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    
    let tap = UITapGestureRecognizer(target: self,
                                     action: #selector(complete))
    bottomView.addGestureRecognizer(tap)
  }
  
  private func buildLayout() {
    collectionView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(64)//(Macro.statusAndNavBarHeight)
      make.left.right.equalToSuperview()
      make.bottom.equalTo(bottomView.snp.top)
    }
    
    bottomView.snp.makeConstraints { (make) in
      make.height.equalTo(45)
      make.left.right.bottom.equalToSuperview()
    }
  }
}

// MARK: - 自定义方法
extension SHCImageCollectionViewController {
  /// 取消
  @objc func cancel() {
    HUD.dismiss()
    dismiss(animated: true, completion: nil)
  }
  
  /// 完成
  @objc func complete() {
    if selectCount() == 0 { return }
    
    // 只能调用一次
    HUD.show(info: "获取图片")
    if completeBtnlock { return }
    completeBtnlock = true
    var assets = [PHAsset]()
    if let indexPaths = collectionView.indexPathsForSelectedItems {
      for item in 0..<indexPaths.count {
        let indexPath = indexPaths[item]
        let asset = assetsFetchResults![indexPath.row]
        assets.append(asset)
      }
      getImage(assets: assets)
    }
  }
  
  /// 重置缓存
  func resetCachedAssets() {
    imageManager.stopCachingImagesForAllAssets()
  }
  
  /// 刷新没有选中的cell
  func reloadNoSelectCell() {
    let items = noSelectIndexPath()
    UIView.setAnimationsEnabled(false)
    collectionView.performBatchUpdates({
      collectionView.reloadItems(at: items)
    }) { (true) in
      UIView.setAnimationsEnabled(true)
    }
  }
  
  /// 获取选中数量
  func selectCount() -> Int{
    return collectionView.indexPathsForSelectedItems?.count ?? 0
  }
  
  /// 没有选中的indexPath
  func noSelectIndexPath() -> [IndexPath] {
    var items = collectionView.indexPathsForVisibleItems
    let selects = collectionView.indexPathsForSelectedItems ?? [IndexPath]()
    
    items = items.compactMap { (item1) -> IndexPath? in
      for item2 in selects {
        if item1.item == item2.item { return nil }
      }
      return item1
    }
    return items
  }
  
  /// 获取图片
  func getImage(assets: [PHAsset]) {
    var images = [UIImage]()
    var maxImgCount = assets.count
    option.deliveryMode = .highQualityFormat
    for asset in assets {
      imageManager.requestImage(for: asset,
                                targetSize: UIScreen.main.bounds.size,
                                contentMode: .aspectFill,
                                options: option) { (image, nfo) in
                                  
                                  if image == nil {
                                    maxImgCount -= 1
                                  }else {
                                    images.append(image!)
                                  }
                                  
                                  if images.count == maxImgCount || maxImgCount == 0 {
                                    self.completeHandler?(images)
                                    self.cancel()
                                  }
      }
    }
  }
}

// MARK: - dalegate
// MARK: collection Delegate
extension SHCImageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return assetsFetchResults?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SHCImageCollectionViewCell
    cell.isDisabled = selectCount() >= maxSelected
    let asset = assetsFetchResults![indexPath.item]
    option.deliveryMode = .fastFormat
    imageManager.requestImage(for: asset,
                              targetSize: assetGridThumbnailSize,
                              contentMode: .aspectFill,
                              options: option) { (image, nfo) in
                                cell.imageView.image = image
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if selectCount() > maxSelected {
      collectionView.deselectItem(at: indexPath, animated: false)
      return
    }
    
    if selectCount() == maxSelected { reloadNoSelectCell() }
    
    bottomView.imageCount = self.selectCount()
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    bottomView.imageCount = self.selectCount()
    
    if selectCount() == maxSelected - 1 { reloadNoSelectCell() }
  }
}

