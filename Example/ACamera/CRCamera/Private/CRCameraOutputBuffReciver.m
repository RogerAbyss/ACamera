//
//  CRCameraOutputBuffReciver.m
//  CRPhotoDocker
//
//  Created by Abyss on 2017/6/23.
//  Copyright © 2017年 Abyss. All rights reserved.
//

#import "CRCameraOutputBuffReciver.h"
#import "exbankcard.h"
#import "excards.h"
#import "RectManager.h"
#import "UIImage+Extend.h"
#import "BankCardSearch.h"
#import "CRCameraScanObjct.h"

@implementation CRCameraOutputBuffReciver

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    @synchronized(self)
    {
        if (self.camera.hasResult) return;
        
        self.camera.processing = YES;
        
        CVBufferRetain(imageBuffer);
        if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
        {
            switch (self.camera.style)
            {
                case CRCameraStyleBankCard:
                {
                    [self parseBankImageBuffer:imageBuffer];
                }
                    break;
                case CRCameraStyleIDCard:
                {
                    [self parseIDCardImageBuffer:imageBuffer];
                }
                    break;
                default:
                    break;
            }
        }
        
        CVBufferRelease(imageBuffer);
    }
}

#pragma mark - Deel

- (void)parseBankImageBuffer:(CVImageBufferRef)imageBuffer
{
    size_t width_t= CVPixelBufferGetWidth(imageBuffer);
    size_t height_t = CVPixelBufferGetHeight(imageBuffer);
    CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
    
    unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
    unsigned char* pixelAddress = baseAddress + offset;
    
    size_t cbCrOffset = NSSwapBigIntToHost(planar->componentInfoCbCr.offset);
    uint8_t *cbCrBuffer = baseAddress + cbCrOffset;
    
    CGSize size = CGSizeMake(width_t, height_t);
    CGRect effectRect = [RectManager getEffectImageRect:size];
    CGRect rect = [RectManager getGuideFrame:effectRect];
    
    int width = ceilf(width_t);
    int height = ceilf(height_t);
    
    unsigned char result [512];
    int resultLen = BankCardNV12(result, 512, pixelAddress, cbCrBuffer, width, height, rect.origin.x, rect.origin.y, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
    
    if(resultLen > 0) {
        
        int charCount = [RectManager docode:result len:resultLen];
        if(charCount > 0) {
            CGRect subRect = [RectManager getCorpCardRect:width height:height guideRect:rect charCount:charCount];
            self.camera.hasResult = YES;
            UIImage *image = [UIImage getImageStream:imageBuffer];
            __block UIImage *subImg = [UIImage getSubImage:subRect inImage:image];
            
            char *numbers = [RectManager getNumbers];
            
            NSString *numberStr = [NSString stringWithCString:numbers encoding:NSASCIIStringEncoding];
            NSString *bank = [BankCardSearch getBankNameByBin:numbers count:charCount];
            
            CRCameraScanObjct *model = [CRCameraScanObjct new];
            
            model.bankNumber = numberStr;
            model.bankName = bank;
            model.bankImage = subImg;
            
            __block CRCameraOutputBuffReciver* weak = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                if (weak.camera.greb) weak.camera.greb(model);
            });
        }
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    self.camera.processing = NO;
}

- (void)parseIDCardImageBuffer:(CVImageBufferRef)imageBuffer
{
    
    CRCameraScanObjct *idInfo = nil;
    
    size_t width= CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
    size_t rowBytes = NSSwapBigIntToHost(planar->componentInfoY.rowBytes);
    unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
    unsigned char* pixelAddress = baseAddress + offset;
    
    static unsigned char *buffer = NULL;
    if (buffer == NULL) {
        buffer = (unsigned char*)malloc(sizeof(unsigned char) * width * height);
    }
    memcpy(buffer, pixelAddress, sizeof(unsigned char) * width * height);
    
    unsigned char pResult[1024];
    int ret = EXCARDS_RecoIDCardData(buffer, (int)width, (int)height, (int)rowBytes, (int)8, (char*)pResult, sizeof(pResult));
    if (ret <= 0) {
        //        NSLog(@"ret=[%d]", ret);
    }
    else {
        self.camera.hasResult = YES;
        NSLog(@"ret=[%d]", ret);
        char ctype;
        char content[256];
        int xlen;
        int i = 0;
        
        idInfo = [CRCameraScanObjct new];
        ctype = pResult[i++];
        idInfo.type = ctype;
        while(i < ret){
            ctype = pResult[i++];
            for(xlen = 0; i < ret; ++i){
                if(pResult[i] == ' ') { ++i; break; }
                content[xlen++] = pResult[i];
            }
            content[xlen] = 0;
            if(xlen) {
                NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                if(ctype == 0x21)
                    idInfo.code = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                else if(ctype == 0x22)
                    idInfo.name = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                else if(ctype == 0x23)
                    idInfo.gender = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                else if(ctype == 0x24)
                    idInfo.nation = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                else if(ctype == 0x25)
                    idInfo.address = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                else if(ctype == 0x26)
                    idInfo.issue = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                else if(ctype == 0x27)
                    idInfo.valid = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
            }
        }
        
        static CRCameraScanObjct *lastIdInfo = nil;
        
        if (self.camera.style == 3)
        {
            if (lastIdInfo == nil)
            {
                lastIdInfo = idInfo;
                idInfo = nil;
            }
//            else
//            {
//                if (![lastIdInfo isEqual:idInfo])
//                {
//                    lastIdInfo = idInfo;
//                    idInfo = nil;
//                }
//            }
        }
        
        if ([lastIdInfo isOK])
        {
            NSLog(@"%@", [lastIdInfo description]);
        }
        else
        {
            idInfo = nil;
        }
    }
    
    if (idInfo != nil) {
        CGSize size = CGSizeMake(width, height);
        CGRect effectRect = [RectManager getEffectImageRect:size];
        CGRect rect = [RectManager getGuideFrame:effectRect];
        UIImage *image = [UIImage getImageStream:imageBuffer];
        UIImage *subImg = [UIImage getSubImage:rect inImage:image];
        idInfo.idImage = subImg;
        
        __block CRCameraOutputBuffReciver* weak = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            if (weak.camera.greb) weak.camera.greb(idInfo);
        });
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    self.camera.processing = NO;
}

@end
