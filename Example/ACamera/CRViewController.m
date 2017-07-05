//
//  CRViewController.m
//  ACamera
//
//  Created by RogerAbyss on 07/04/2017.
//  Copyright (c) 2017 RogerAbyss. All rights reserved.
//

#import "CRViewController.h"
#import "CRCameraController.h"

#import "OverlayView.h"

@interface CRViewController ()
@property (nonatomic, strong) CRCameraController* controller;
@end

@implementation CRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    CGRect rect = [OverlayView getOverlayFrame:[UIScreen mainScreen].bounds];
    OverlayView* overlayView = [[OverlayView alloc] initWithFrame:rect];
    
    _controller = [CRCameraController cameraDisplayInController:self style:CRCameraStyleIDCard layer:overlayView];
    
    _controller.camera.greb = ^(CRCameraScanObjct* info){ NSLog(@"%@",info);};
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
