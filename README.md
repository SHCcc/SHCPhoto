# SHCPhoto

  图片浏览器、图片选择器

### 使用
```
  - pod 'SHCPhoto'
```
  ### 功能

```
- 图片浏览器
 - 图片的浏览
 - 图片的放大
- 图片选择器
 - 图片的选择
```


### 图片选择


- 创建方式

  ```
  - vc: 控制器
  - maxSelected: 图片选择的最大值
  - call: 图片回调
  SHCImagePickerViewController.show(vc: UIViewController, 
  									maxSelected: Int, 
									call:@escaping ((_ images:[UIImage]?)->()))
  ```

### 图片浏览

- 创建方式

```
- vc: 控制器
- delegate: 代理
- index: 图片的数量
let vc = PhotoBrowserViewController(viewCotroller: UIViewController,
									delegate: PhotoBrowserViewDelegate)
vc.show(index: Int)
```
- 实现代理
```
/// 返回图片数量
func numberOfPhotos(in photoBrowser: PhotoBrowserViewController) -> Int {
	return 图片数量
}

/// 实现本方法以返回默认图片，缩略图或占位图
func photoBrowser(_ photoBrowser: PhotoBrowserViewController, thumbnailImageForIndex index: Int) -> UIImage? {
	return 当前的图片
}

/// 实现本方法以返回默认图所在view，在转场动画完成后将会修改这个view的hidden属性
/// 比如你可返回ImageView，或整个Cell
func photoBrowser(_ photoBrowser: PhotoBrowserViewController, thumbnailViewForIndex index: Int) -> UIView? {
	return 图片所在的View
}

/// 实现本方法以返回高质量图片
func photoBrowser(_ photoBrowser: PhotoBrowserViewController, highQualityImageForIndex index: Int) -> UIImage? {
	return 高质量图片
}

/// 实现本方法以返回高质量图片的url
func photoBrowser(_ photoBrowser: PhotoBrowserViewController, highQualityUrlStringForIndex index: Int) -> URL? {
	return 高质量图片的url
}

/// 长按时回调。可选
func photoBrowser(_ photoBrowser: PhotoBrowserViewController, didLongPressForIndex index: Int, image: UIImage) {
}
```
