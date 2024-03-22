#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>
#import "AirshipCapacitorBootstrap.h"

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(AirshipPlugin, "Airship",
           CAP_PLUGIN_METHOD(perform, CAPPluginReturnPromise);
)
