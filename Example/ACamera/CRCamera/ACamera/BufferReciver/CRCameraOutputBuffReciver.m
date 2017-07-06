//
//  CRCameraOutputBuffReciver.m
//  CRPhotoDocker
//
//  Created by Abyss on 2017/6/23.
//  Copyright © 2017年 Abyss. All rights reserved.
//

#import "CRCameraOutputBuffReciver.h"

#import "exbankcard.h"
#import "excards.h"
#import "RectManager.h"
#import "UIImage+Extend.h"
#import "BankCardSearch.h"

#import "CRCameraScanObjct.h"
#import "CRPhotoDetector.h"

@implementation CRCameraOutputBuffReciver

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    @synchronized(self)
    {
        if (self.camera.hasResult) return;
        
        self.camera.processing = YES;
        
        CVBufferRetain(imageBuffer);
        if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
        {
            switch (self.camera.style)
            {
                case CRCameraStyleBankCard:
                {
                    [self parseBankImageBuffer:imageBuffer];
                }
                    break;
                case CRCameraStyleIDCard:
                {
                    [self parseIDCardImageBuffer:imageBuffer];
                }
                    break;
                case CRCameraStyleCode:
                {
                    // 使用CIDetector 处理buffer方式识别
                    // CIDetector锁死buffer造成内存无法释放, 系统问题
                    // 转用AV框架处理二维码相关
                }
                default:
                    break;
            }
        }
        
        CVBufferRelease(imageBuffer);
    }
}

#pragma mark - Deel

- (void)parseBankImageBuffer:(CVImageBufferRef)imageBuffer
{
    CRCameraScanObjct* obj = [CRPhotoDetector getBankCardFrom:imageBuffer camera:self.camera];
    
    if (obj.success && self.camera.greb)
    {
        self.camera.greb(obj);
    }

    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    self.camera.processing = NO;
}

- (void)parseIDCardImageBuffer:(CVImageBufferRef)imageBuffer
{
    CRCameraScanObjct* obj = [CRPhotoDetector getIDCardFrom:imageBuffer camera:self.camera];
    
    if (obj.success && self.camera.greb)
    {
        self.camera.greb(obj);
    }
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    self.camera.processing = NO;
}

@end
