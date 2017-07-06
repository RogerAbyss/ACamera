//
//  CRCameraScanObjct.h
//  CRPhotoDocker
//
//  Created by Abyss on 2017/6/23.
//  Copyright © 2017年 Abyss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRBaseCameraControl.h"
#import "CRCameraDefine.h"

@interface CRCameraScanObjct : NSObject

@property (nonatomic, assign) CRCameraStyle style;
@property (nonatomic, assign, readonly) BOOL success;

- (NSString *)description;

@property (copy, nonatomic) NSString* codeString;

@property (assign, nonatomic) int type;             //1:正面  2:反面
@property (copy, nonatomic) NSString *code;         //身份证号
@property (copy, nonatomic) NSString *name;         //姓名
@property (copy, nonatomic) NSString *gender;       //性别
@property (copy, nonatomic) NSString *nation;       //民族
@property (copy, nonatomic) NSString *address;      //地址

@property (copy, nonatomic) NSString *issue;        //签发机关
@property (copy, nonatomic) NSString *valid;        //有效期

@property (nonatomic, strong) UIImage *idImage;     //身份证图片


@property (nonatomic, copy) NSString *bankNumber;   //银行卡号
@property (nonatomic, copy) NSString *bankName;     //银行名称

@property (nonatomic, strong) UIImage *bankImage;   //银行卡照片


@end
