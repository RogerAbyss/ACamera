//
//  CRCameraController.h
//  CRPhotoDocker
//
//  Created by Abyss on 2017/6/23.
//  Copyright © 2017年 Abyss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRBaseCamera.h"

@interface CRCameraController : UIViewController

@property (nonatomic, strong) CRBaseCamera* camera;

+ (instancetype)cameraDisplayInController:(UIViewController *)controller style:(CRCameraStyle)style layer:(CALayer *)layer;

@end
