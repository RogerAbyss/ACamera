//
//  CRPhotoDetector.h
//  ACamera
//
//  Created by abyss on 2017/7/6.
//  Copyright © 2017年 RogerAbyss. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CRCameraScanObjct;
@class CRBaseCamera;
@interface CRPhotoDetector : NSObject

+ (CRCameraScanObjct *)getIDCardFrom:(CVImageBufferRef)imageBuffer camera:(CRBaseCamera *)camera;
+ (CRCameraScanObjct *)getBankCardFrom:(CVImageBufferRef)imageBuffer camera:(CRBaseCamera *)camera;
+ (CRCameraScanObjct *)getQRCodeFrom:(CVImageBufferRef)imageBuffer camera:(CRBaseCamera *)camera;
+ (CRCameraScanObjct *)getStringFrom:(CVImageBufferRef)imageBuffer camera:(CRBaseCamera *)camera;

@end
