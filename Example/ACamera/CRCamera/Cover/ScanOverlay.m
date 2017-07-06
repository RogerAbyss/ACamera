
#import "ScanOverlay.h"
#import "RectManager.h"

@interface ScanOverlay()

@property (nonatomic, assign) CGFloat r;
@property (nonatomic, assign) CGFloat g;
@property (nonatomic, assign) CGFloat b;

@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, copy) NSString* txt;

@property (nonatomic, assign) int lineLenght;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel* label;

@end

@implementation ScanOverlay

+ (instancetype)cover
{
    return [ScanOverlay coverWith:@"放入你的文字" r:248 g:62 b:75 alpha:0.8];
}

+ (instancetype)coverWith:(NSString *)txt r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha
{
    CGRect rect = [ScanOverlay getOverlayFrame:[UIScreen mainScreen].bounds];
    ScanOverlay* cover = [[ScanOverlay alloc] initWithFrame:rect];
    
    cover.r = r;
    cover.g = g;
    cover.b = b;
    
    cover.alpha = alpha;
    
    cover.txt = txt;
    
    return cover;
}

- (void)setTxt:(NSString *)txt
{
    _txt = txt;
    
    self.label.text = _txt?:@"";
}

- (NSTimer *)timer
{
    if (!_timer)
        _timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
    
    return _timer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat width = frame.size.height;
        CGFloat height = frame.size.width;
        
        self.backgroundColor = [UIColor clearColor];
        _lineLenght = height / 10;

        [self.timer fire];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor lightGrayColor];
        _label.font = [UIFont boldSystemFontOfSize:20];
        _label.text = @"";
        _label.numberOfLines = 0;
        [self addSubview:_label];
        
        CGAffineTransform transform = CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
        _label.transform = transform;
        
        float x = height * 22 / 54;
        x = x + (height - x) / 2;
        _label.center = CGPointMake(x, width/2);
    }
    return self;
}


- (void)timerFire:(id)notice
{
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [self.timer invalidate];
}

//画边框和线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 8.0);
    CGContextSetRGBStrokeColor(context, _r/255.0, _g/255.0, _b/255.0, _alpha);
    
    CGContextBeginPath(context);
    
    CGPoint pt = rect.origin;
    CGContextMoveToPoint(context, pt.x, pt.y+_lineLenght);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y+_lineLenght);
    
    pt = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    CGContextMoveToPoint(context, pt.x, pt.y-_lineLenght);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    
    pt = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
    CGContextAddLineToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y-_lineLenght);
    CGContextStrokePath(context);
    
    
    static float moveX = 0;
    static float distance = 2;
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2);
    CGPoint p1, p2;
    
    moveX += distance;
    if (moveX > rect.size.width) {
        distance = -2;
    } else if (moveX < rect.origin.x){
        distance = 2;
    }
    p1 = CGPointMake(rect.origin.x + moveX, rect.origin.y);
    p2 = CGPointMake(rect.origin.x + moveX, rect.origin.y + rect.size.height);
    CGContextMoveToPoint(context,p1.x, p1.y);
    CGContextAddLineToPoint(context, p2.x, p2.y);
    CGContextStrokePath(context);
    
}

+ (CGRect)getOverlayFrame:(CGRect)rect
{
    float previewWidth = rect.size.width;
    float previewHeight = rect.size.height;
    
    float cardh, cardw;
    float left, top;
    
    cardw = previewWidth*70/100;
    if(previewWidth < cardw)
        cardw = previewWidth;
    
    cardh = (int)(cardw / 0.63084f);
    
    left = (previewWidth-cardw)/2;
    top = (previewHeight-cardh)/2;
    
    return CGRectMake(left, top, cardw, cardh);
}



@end
