//
//  AZScanner.h
//  UseScanKitFrame
//
//  Created by GMAdmin on 2023/9/21.
//  Copyright (c) 2023 Az. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AZScanner : NSObject
- (instancetype)initWithPreviewView:(UIView *)previewView;
+ (void)requestCameraPermissionWithSuccess:(void (^)(BOOL success))successBlock;
- (void)startScanningWithResultBlock:(void (^)(NSDictionary *codeInfo))resultBlock;
@end

NS_ASSUME_NONNULL_END
