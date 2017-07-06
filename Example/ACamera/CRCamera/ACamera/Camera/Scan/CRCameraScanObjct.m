//
//  CRCameraScanObjct.m
//  CRPhotoDocker
//
//  Created by Abyss on 2017/6/23.
//  Copyright © 2017年 Abyss. All rights reserved.
//

#import "CRCameraScanObjct.h"

@implementation CRCameraScanObjct

- (CRCameraStyle)style
{
    int code = CRCameraStyleUnknow;
    
    if (_bankNumber)
    {
        code = CRCameraStyleBankCard;
    }
    else if (_code || _valid)
    {
        code = CRCameraStyleIDCard;
    }
    else if (_codeString)
    {
        code = CRCameraStyleCode;
    }
    
    return code;
}

- (NSString *)description
{
    NSString* des = @"";
    
    switch (self.style)
    {
        case CRCameraStyleUnknow:
        {
        }
            break;
        case CRCameraStyleCode:
        {
            des = [NSString stringWithFormat:@"结果:%@\n",
                   _codeString];
        }
            break;
        case CRCameraStyleIDCard:
        {
            des = [NSString stringWithFormat:@"身份证号:%@\n姓名:%@\n性别:%@\n民族:%@\n地址:%@\n签发机关:%@\n有效期:%@",
                   _code, _name, _gender, _nation, _address, _issue, _valid];
        }
            break;
        case CRCameraStyleBankCard:
        {
            des = [NSString stringWithFormat:@"银行卡号:%@\n银行名称:%@\n银行图片:%@\n",
                   _bankNumber, _bankName, _bankImage];
        }
            break;
        default:
            return des;
            break;
    }
    
    return des;
}

- (BOOL)isOK
{
    if (_code !=nil && _name!=nil && _gender!=nil && _nation!=nil && _address!=nil)
    {
        if (_code.length>0 && _name.length >0 && _gender.length>0 && _nation.length>0 && _address.length>0)
        {
            return YES;
        }
    }
    else if (_issue !=nil && _valid!=nil)
    {
        if (_issue.length>0 && _valid.length >0)
        {
            return YES;
        }
    }
    return NO;
}


@end
