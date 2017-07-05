#import "CRBaseCamera.h"
#import "CRCameraOutputBuffReciver.h"
#import "excards.h"

@interface CRBaseCamera ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, assign) BOOL done;
@property (nonatomic, assign) dispatch_queue_t queue;
@property (nonatomic, strong) CRCameraOutputBuffReciver* reciver;
@end
@implementation CRBaseCamera
@synthesize processing = _processing;
@synthesize session = _session;
@synthesize input = _input;
@synthesize output = _output;
@synthesize device = _device;
@synthesize previewLayer = _previewLayer;
@synthesize hasResult = _hasResult;

#pragma mark - INIT

+ (instancetype)cameraWithStyle:(CRCameraStyle)style
{
    return [[self alloc] initWithCameraStyle:style];
}

- (instancetype)initWithCameraStyle:(CRCameraStyle)style
{
    self = [super init];
    if(self)
    {
        _style = style;
        
        self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:nil];
    }
    
    return self;
}

#pragma mark - Property

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer)
    {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _previewLayer.frame = [UIScreen mainScreen].bounds;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    return _previewLayer;
}

- (AVCaptureSession *)session
{
	if (!_session)
	{
		_session = [[AVCaptureSession alloc] init];
        
        [_session beginConfiguration];
    }

	return _session;
}

- (AVCaptureDevice *)device
{
    if (!_device)
    {
        _device =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return _device;
}

- (AVCaptureVideoDataOutput *)output
{
    if (!_output)
    {
        _output = [[AVCaptureVideoDataOutput alloc] init];
        
        _output.alwaysDiscardsLateVideoFrames = YES;
        _output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], (id)kCVPixelBufferPixelFormatTypeKey, nil];
    }
    
    return _output;
}

- (CRCameraOutputBuffReciver *)reciver
{
    if (!_reciver)
    {
        _reciver = [[CRCameraOutputBuffReciver alloc] init];
        _reciver.camera = self;
    }
    
    return _reciver;
}

#pragma mark - Setter 

- (void)setInput:(AVCaptureDeviceInput *)input
{
    _input = input;
}

#pragma mark - Running 

- (void)runningInQueue:(dispatch_queue_t)queue
{
    // 配置线程
    _queue = queue;
    
    // 配置输入流
    if(![self configureInput])
    {
        NSLog(@"输入流错误");
        return;
    }
    
    // 配置输出流
    if(![self configureOutput])
    {
        NSLog(@"输出流错误");
        return;
    }
    
    // 配置Connection
    [self configConnection];
    
    
    switch (self.style)
    {
        case 0:
        {
        }
            break;
        case 1:
        {
        }
            break;
        case 2:
        {
        }
            break;
        case 3:
        {
            [self configIDScan];
        }
            break;
        default:
            break;
    }
    
    [self.session commitConfiguration];
    self.done = YES;
    
    [self.session startRunning];
}

#pragma mark - Deel

- (BOOL)configureInput
{
    if ([self.session canAddInput:self.input])
    {
        [self.session addInput:self.input];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)configureOutput
{
    [self.output setSampleBufferDelegate:self queue:_queue];
    
    if ([self.session canAddOutput:self.output])
    {
        [self.session addOutput:self.output];
        
        return YES;
    }
    
    return NO;
}

- (void)configConnection
{
    AVCaptureConnection *videoConnection;
    for (AVCaptureConnection *connection in [self.output connections])
    {
        for (AVCaptureInputPort *port in[connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                videoConnection = connection;
            }
        }
    }
    if ([videoConnection isVideoStabilizationSupported])
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            videoConnection.enablesVideoStabilizationWhenAvailable = YES;
        }
        else {
            videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
}

#pragma mark - IDScan

- (void)configIDScan
{
    const char *thePath = [[[NSBundle mainBundle] resourcePath] UTF8String];
    int ret = EXCARDS_Init(thePath);
    if (ret != 0)
    {
        NSLog(@"身份证扫描初始化失败：ret=%d", ret);
    }
}

#pragma mark - Delegate


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if ([captureOutput isEqual:self.output])
    {
        if(self.processing == NO)
        {
            [self.reciver captureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection];
        }
    }
}

#pragma mark - Control

- (void)startSession
{
    if (![self.session isRunning] && self.done) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.session startRunning];
            [self resetConfig];
        });
    }
}

- (void)stopSession
{
    if ([self.session isRunning]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.session stopRunning];
            [self resetConfig];
        });
    }
}

- (void)resetConfig
{
    self.processing = NO;
    self.hasResult  = NO;
    
    if ([self.session canAddOutput:self.output])
        [self.session addOutput:self.output];
}


@end
