#import "CRBaseCameraControl.h"

@interface CRBaseCamera : NSObject <CRBaseCameraControl>

@property (nonatomic, assign) CRCameraStyle style;
@property (nonatomic, copy) GrebInfo greb;

+ (instancetype)cameraWithStyle:(CRCameraStyle)style;

/** 运行 */
- (void)runningInQueue:(dispatch_queue_t)queue;

@end


