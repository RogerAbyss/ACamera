//
//  CRCameraController.m
//  CRPhotoDocker
//
//  Created by Abyss on 2017/6/23.
//  Copyright © 2017年 Abyss. All rights reserved.
//

#import "CRCameraController.h"
#import "CRCameraOutputBuffReciver.h"

@interface CRCameraController () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (nonatomic, strong) CRCameraOutputBuffReciver* reciver;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation CRCameraController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _queue = dispatch_queue_create("com.abyss.docker.camera", DISPATCH_QUEUE_SERIAL);
    
    [self.view.layer  addSublayer:self.camera.previewLayer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.camera stopSession];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.camera startSession];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.camera runningInQueue:_queue];
}

- (CRBaseCamera *)camera
{
    if (!_camera)
    {
        _camera = [[CRBaseCamera alloc] init];
    }
    
    return _camera;
}

+ (instancetype)cameraDisplayInController:(UIViewController *)controller style:(CRCameraStyle)style layer:(UIView *)layer
{
    CRCameraController* cameraController = [[CRCameraController alloc] init];
    cameraController.camera = [CRBaseCamera cameraWithStyle:style];

    [controller presentViewController:cameraController animated:YES completion:NULL];
    [cameraController.view addSubview:layer];
    
    return cameraController;
}

@end
