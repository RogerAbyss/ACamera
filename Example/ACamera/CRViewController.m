//
//  CRViewController.m
//  ACamera
//
//  Created by RogerAbyss on 07/04/2017.
//  Copyright (c) 2017 RogerAbyss. All rights reserved.
//

#import "CRViewController.h"
#import "CRCameraController.h"

#import "ScanOverlay.h"

@interface CRViewController ()
@property (nonatomic, strong) CRCameraController* controller;
@end

@implementation CRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _controller = [CRCameraController cameraDisplayInController:self
                                                              style:CRCameraDetetorTypeCode
                                                              cover:[ScanOverlay cover]
                                                               greb:^(CRCameraScanObjct* info){
                                                                   NSLog(@"%@",info);
                                                                   [_controller dismiss];
                                                               }];
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
