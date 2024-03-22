/* Copyright Airship and Contributors */

#import "AirshipCapacitorBootstrap.h"

#if __has_include(<UACapacitorAirship/UACapacitorAirship-Swift.h>)
#import <UACapacitorAirship/UACapacitorAirship-Swift.h>
#else
#import <Capacitor/
#import "UACapacitorAirship-Swift.h"
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
