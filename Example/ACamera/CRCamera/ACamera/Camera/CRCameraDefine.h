//
//  CRCameraDefine.h
//  CRPhotoDocker
//
//  Created by Abyss on 2017/6/23.
//  Copyright © 2017年 Abyss. All rights reserved.
//

#ifndef CRCameraDefine_h
#define CRCameraDefine_h

@class CRCameraScanObjct;
typedef NS_ENUM(NSInteger, CRCameraDetetorType)
{
    CRCameraDetetorTypeUnknow = -1,
    CRCameraDetetorTypeNormal = 0,
    
    CRCameraDetetorTypeCode,
    
    CRCameraDetetorTypeBankCard,
    CRCameraDetetorTypeIDCard,
};

typedef void(^GrebInfo)(CRCameraScanObjct* info);

#endif /* CRCameraDefine_h */
