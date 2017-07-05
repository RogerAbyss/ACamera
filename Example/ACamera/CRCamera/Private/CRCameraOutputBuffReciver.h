//
//  CRCameraOutputBuffReciver.h
//  CRPhotoDocker
//
//  Created by Abyss on 2017/6/23.
//  Copyright © 2017年 Abyss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRBaseCamera.h"

@interface CRCameraOutputBuffReciver : NSObject
@property (nonatomic, weak) CRBaseCamera* camera;

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;
@end
