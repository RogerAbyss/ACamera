#import "CRBaseCameraControl.h"

@interface CRBaseCamera : NSObject <CRBaseCameraControl>

@property (nonatomic, assign) CRCameraDetetorType style;
@property (nonatomic, copy) GrebInfo greb;

+ (instancetype)cameraWithStyle:(CRCameraDetetorType)style;

/** 运行 */
- (void)runningInQueue:(dispatch_queue_t)queue;

@end


