//
//  ImagePickerViewController.swift
//  testPhoto
//
//  Created by 邵焕超 on 2018/5/28.
//  Copyright © 2018年 邵焕超. All rights reserved.
//

import UIKit
import Photos
import SHCHUD

//相簿列表项
struct ImageAlbumItem {
  //相簿名称`
  var title:String?
  //相簿内的资源
  var fetchResult:PHFetchResult<PHAsset>
}

class SHCImagePickerViewController: UIViewController {
  
  let tableView = UITableView()
  
  //相册集合
  var items = [ImageAlbumItem]()
  
  /// 最大图片选择
  var maxSelected = 4
  
  //照片选择完毕后的回调
  var completeHandler:((_ images:[UIImage]?)->())?
  
  class func show(vc: UIViewController, maxSelected: Int, call:@escaping ((_ images:[UIImage]?)->())) {
    let imageVC = SHCImagePickerViewController()
    imageVC.maxSelected = maxSelected
    imageVC.completeHandler = call
    let nav = UINavigationController(rootViewController: imageVC)
    vc.present(nav, animated: true, completion: nil)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    PHPhotoLibrary.requestAuthorization { (status) in
      if status != .authorized { return }
      
      let smartOptions = PHFetchOptions()
      let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                subtype: .albumRegular,
                                                                options: smartOptions)
      
      self.convertCollection(collection: smartAlbums)
      
      let userColletion = PHCollectionList.fetchTopLevelUserCollections(with: nil)
      self.convertCollection(collection: userColletion as! PHFetchResult<PHAssetCollection>)
      
      // 排序
      self.items.sort(by: { (item1, item2) -> Bool in
        return item1.fetchResult.count > item2.fetchResult.count
      })
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
        
        // 默认进入第一个
        let vc = SHCImageCollectionViewController()
        vc.assetsFetchResults = self.items.first?.fetchResult
        vc.title = self.items.first?.title
        vc.maxSelected = self.maxSelected
        vc.completeHandler = self.completeHandler
        self.navigationController?.pushViewController(vc, animated: false)
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    buildUI()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    HUD.dismiss()
  }
}

// MARK: - UI
extension SHCImagePickerViewController {
  fileprivate func buildUI() {
    view.backgroundColor = UIColor.white
    view.addSubview(tableView)
        
    navigationItem.title = "相册"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(cancel))
    buildSubView()
    buildLayout()
  }
  
  private func buildSubView() {
    tableView.rowHeight = 55
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(SHCImagePickerCell.self, forCellReuseIdentifier: "cell")
  }
  
  private func buildLayout() {
    tableView.frame = view.bounds
  }
}

// MARK: - 自定义方法
extension SHCImagePickerViewController {
  @objc func cancel() {
    dismiss(animated: true, completion: nil)
  }
  
  //由于系统返回的相册集名称为英文，我们需要转换为中文
  private func titleOfAlbumForChinse(title:String?) -> String? {
    if title == "Slo-mo" {
      return "慢动作"
    } else if title == "Recently Added" {
      return "最近添加"
    } else if title == "Favorites" {
      return "个人收藏"
    } else if title == "Recently Deleted" {
      return "最近删除"
    } else if title == "Videos" {
      return "视频"
    } else if title == "All Photos" {
      return "所有照片"
    } else if title == "Selfies" {
      return "自拍"
    } else if title == "Screenshots" {
      return "屏幕快照"
    } else if title == "Camera Roll" {
      return "相机胶卷"
    }
    return title
  }

  //转化处理获取到的相簿
  private func convertCollection(collection: PHFetchResult<PHAssetCollection>){
    for i in 0..<collection.count{
      //获取出但前相簿内的图片
      let resultsOptions = PHFetchOptions()
      resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                         ascending: false)]
      resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                             PHAssetMediaType.image.rawValue)
      let c = collection[i]
      let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
      //没有图片的空相簿不显示
      if assetsFetchResult.count > 0 {
        let title = titleOfAlbumForChinse(title: c.localizedTitle)
        items.append(ImageAlbumItem(title: title,
                                    fetchResult: assetsFetchResult))
      }
    }
  }

}

// MARK: - delegate
// MARK: tableView
extension SHCImagePickerViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SHCImagePickerCell
    cell.titleLabel.text = items[indexPath.item].title
    cell.countLabel.text = "(\(items[indexPath.item].fetchResult.count))"
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let cell = tableView.cellForRow(at: indexPath) as? SHCImagePickerCell else { return }
    
    let vc = SHCImageCollectionViewController()
    vc.assetsFetchResults = items[indexPath.item].fetchResult
    vc.title = cell.titleLabel.text
    vc.completeHandler = completeHandler
    navigationController?.pushViewController(vc, animated: true)
  }
}

