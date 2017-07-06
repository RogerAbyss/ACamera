//
//  CRBaseCameraControl.h
//  CRPhotoDocker
//
//  Created by Abyss on 2017/6/23.
//  Copyright © 2017年 Abyss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "CRCameraScanObjct.h"
#import "CRCameraDefine.h"

@protocol CRBaseCameraControl <NSObject>

@property (nonatomic, strong) AVCaptureSession* session;

/** 设备 */
@property (nonatomic, strong) AVCaptureDevice *device;

/** 输入流 */
@property (nonatomic, strong) AVCaptureDeviceInput* input;
/** 输出流 */
/** AVCaptureVideoDataOutput
    AVCaptureMetadataOutput
 */
@property (nonatomic, strong) AVCaptureOutput* output;

/** 预览的Layer */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
/** 是否在处理中 */
@property (nonatomic, assign) BOOL processing;
/** 是否已经得出结果 */
@property (nonatomic, assign) BOOL hasResult;

/** 分别在ViewWillAppear和ViewWillDisappear调用 */
- (void)startSession;
- (void)stopSession;

/** 重置processing和hasResult的状态 **/
- (void)resetConfig;

@end
