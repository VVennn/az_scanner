//
//  AZScanner.m
//  UseScanKitFrame
//
//  Created by GMAdmin on 2023/9/21.
//  Copyright (c) 2023 Az. All rights reserved.
//

#import "AZScanner.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ScanKitFrameWork/ScanKitFrameWork.h>

@interface AZScanner()<AVCaptureVideoDataOutputSampleBufferDelegate>{
    AVCaptureDevice *captureDevice;
    
    AVCaptureVideoDataOutput *stillVideoDataOutput;
    AVCaptureConnection *videoConnect;
    
    NSDictionary *resultDic;
}
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVidoPreviewLayer;
@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, copy) void (^resultBlock)(NSDictionary * codeInfos);
@end

@implementation AZScanner

- (instancetype)init {
NSAssert(NO, @"AZScanner init is not supported. Please use initWithPreviewView: \
             to instantiate a AZScanner");
    return nil;
}

- (instancetype)initWithPreviewView:(UIView *)previewView {
    self = [super init];
    if (self) {
        _previewView = previewView;
        [self initData];
    }
    return self;
}

- (void)initData{
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [_captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            captureDevice = device;
        }
    }
    if (!captureDevice) {
        NSAssert(NO, @"AZScanner Rear camera unable to enable");
        return;
    }
    if (captureDevice.isFocusPointOfInterestSupported &&[captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error = nil;
        [captureDevice lockForConfiguration:&error];
        [captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [captureDevice unlockForConfiguration];
    }
    [captureDevice lockForConfiguration:nil];
    captureDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    BOOL exposureBool = [captureDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure];
    if (exposureBool == NO) {
        NSLog(@"The phone does not support exposure mode");
    }
    
    NSError *error = nil;
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    stillVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [stillVideoDataOutput setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [stillVideoDataOutput setSampleBufferDelegate:self queue:queue];
    [_captureSession addOutput:stillVideoDataOutput];
    
    videoConnect = [stillVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([videoConnect isVideoOrientationSupported]){
        [videoConnect setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    _captureVidoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    CALayer *layer = _previewView.layer;
    layer.masksToBounds = YES;
    _captureVidoPreviewLayer.frame = _previewView.bounds;
    _captureVidoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [layer addSublayer:_captureVidoPreviewLayer];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    @autoreleasepool{
        if(output == stillVideoDataOutput){
            CFRetain(sampleBuffer);
            resultDic = [HmsBitMap bitMapForSampleBuffer:sampleBuffer withOptions:[[HmsScanOptions alloc] initWithScanFormatType:ALL Photo:false]];
            if (resultDic.count == 0){
                CFRelease(sampleBuffer);
                return;
            }
            if (_captureSession.isRunning){
                [_captureSession stopRunning];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.resultBlock(self->resultDic);
            });
            CFRelease(sampleBuffer);
        }
    }
}

- (void)dealloc{
    [self.captureSession removeInput:self.captureDeviceInput];
    self.captureSession = nil;
    self.captureDeviceInput = nil;
    self->stillVideoDataOutput = nil;
}

+ (BOOL)cameraIsPresent {
    // capture device is nil if status is AVAuthorizationStatusRestricted
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] != nil;
}

+ (void)requestCameraPermissionWithSuccess:(void (^)(BOOL))successBlock {
    if (![self cameraIsPresent]) {
        successBlock(NO);
        return;
    }
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
            successBlock(YES);
            break;
            
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            successBlock(NO);
            break;
            
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    successBlock(granted);
                });
                
            }];
            break;
    }
}

- (void)startScanningWithResultBlock:(void (^)(NSDictionary *codeInfo))resultBlock {
    self.resultBlock = resultBlock;
    if (!_captureSession.isRunning) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_captureSession startRunning];
        });
    }
}
@end
