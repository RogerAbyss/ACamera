#import <UIKit/UIKit.h>

@interface ScanOverlay : UIView

+ (instancetype)cover;
+ (instancetype)coverWith:(NSString *)txt r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b alpha:(CGFloat)alpha;

@end
