//
//  CRCameraScanObjct.m
//  CRPhotoDocker
//
//  Created by Abyss on 2017/6/23.
//  Copyright © 2017年 Abyss. All rights reserved.
//

#import "CRCameraScanObjct.h"

@implementation CRCameraScanObjct

- (CRCameraDetetorType)style
{
    int code = CRCameraDetetorTypeUnknow;
    
    if (_bankNumber)
    {
        code = CRCameraDetetorTypeBankCard;
    }
    else if (_code || _valid)
    {
        code = CRCameraDetetorTypeIDCard;
    }
    else if (_codeString)
    {
        code = CRCameraDetetorTypeCode;
    }
    
    return code;
}

- (BOOL)success
{
    switch (self.style)
    {
        case CRCameraDetetorTypeUnknow:
        {
            return NO;
        }
            break;
        case CRCameraDetetorTypeCode:
        {
            return (_codeString&&_codeString.length>0);
        }
            break;
        case CRCameraDetetorTypeIDCard:
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
            break;
        case CRCameraDetetorTypeBankCard:
        {
            return (_bankNumber&&_bankName);
        }
            break;
        default:
            break;
    }
 
    return NO;
}

- (NSString *)description
{
    NSString* des = @"";
    
    switch (self.style)
    {
        case CRCameraDetetorTypeUnknow:
        {
        }
            break;
        case CRCameraDetetorTypeCode:
        {
            des = [NSString stringWithFormat:@"结果:%@\n",
                   _codeString];
        }
            break;
        case CRCameraDetetorTypeIDCard:
        {
            des = [NSString stringWithFormat:@"身份证号:%@\n姓名:%@\n性别:%@\n民族:%@\n地址:%@\n签发机关:%@\n有效期:%@",
                   _code, _name, _gender, _nation, _address, _issue, _valid];
        }
            break;
        case CRCameraDetetorTypeBankCard:
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


@end
