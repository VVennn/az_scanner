#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MTBBarcodeScanner.h"

FOUNDATION_EXPORT double az_scannerVersionNumber;
FOUNDATION_EXPORT const unsigned char az_scannerVersionString[];

