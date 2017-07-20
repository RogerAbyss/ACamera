# ACamera

- [x] 大陆身份证识别
- [x] 常用银行卡识别
- [x] 二维码识别
- [x] 动态识别与静态识别
- [ ] 相机
- [ ] 摄像机

ACamera是一个功能独立的相机,一句话调用非常方便。
界面我简单写了一个例子,大家自己完善UI。 

## Install & Useage

复制ACamera文件到你的项目,一句话调用
```
        _controller = [CRCameraController cameraDisplayInController:self
                                                              style:CRCameraDetetorTypeCode
                                                              cover:[ScanOverlay cover]
                                                               greb:^(CRCameraScanObjct* info){
                                                                   NSLog(@"%@",info);
                                                                   [_controller dismiss];
                                                               }];

```

## Important！

解析静态库来自[BrooksWon](https://github.com/BrooksWon/ocr_savingCard)
不能以pod方式提供
**只支持真机！！！**

## Author

RogerAbyss, roger_ren@qq.com

## License

ACamera is available under the MIT license. See the LICENSE file for more info.
