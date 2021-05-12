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

<<<<<<< HEAD
=======
#import "GULAppDelegateSwizzler.h"
#import "GULApplication.h"
#import "GULSceneDelegateSwizzler.h"
#import "GULAppEnvironmentUtil.h"
#import "GULHeartbeatDateStorage.h"
#import "GULKeychainStorage.h"
#import "GULKeychainUtils.h"
#import "GULSecureCoding.h"
#import "GULURLSessionDataResponse.h"
#import "NSURLSession+GULPromises.h"
#import "GULLogger.h"
>>>>>>> b0fe4ede551b697175ef2c12175fcf3e42038404
#import "GULLoggerLevel.h"
#import "GULNSData+zlib.h"

FOUNDATION_EXPORT double GoogleUtilitiesVersionNumber;
FOUNDATION_EXPORT const unsigned char GoogleUtilitiesVersionString[];

