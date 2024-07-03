/* Copyright Airship and Contributors */

#import "AirshipCapacitorBootstrap.h"

#if __has_include(<UACapacitorAirship/UACapacitorAirship-Swift.h>)
#import <UACapacitorAirship/UACapacitorAirship-Swift.h>
#elif __has_include("UACapacitorAirship-Swift.h")
#import "UaCapacitorAirship-Swift.h"
#else
@import UaCapacitorAirshipPlugin;
#endif

@implementation AirshipCapacitorBootstrap


+ (void)load {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:UIApplicationDidFinishLaunchingNotification
                        object:nil
                         queue:nil usingBlock:^(NSNotification * _Nonnull note) {

        [AirshipCapacitorAutopilot.shared onApplicationDidFinishLaunchingWithLaunchOptions:note.userInfo];
    }];
}
@end
