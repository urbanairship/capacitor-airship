import UIKit
import Capacitor

import AirshipKit
import Combine

// Predicate for named user filtering on the message extra `named_user`
fileprivate class NamedUserMessageCenterPredicate: MessageCenterPredicate {
    let namedUser: String?

    init(namedUser: String?) {
        self.namedUser = namedUser
    }

    func evaluate(message: MessageCenterMessage) -> Bool {
        guard let messageUser = message.extra["named_user"] else {
            return true
        }
        return messageUser == namedUser
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// Used in combine to store susbcriptions
    private var subscriptions: Set<AnyCancellable> = Set()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }

        NotificationCenter.default.addObserver(forName: AirshipNotifications.AirshipReady.name, object: nil, queue: .main) { _ in
            // Set to nil until we are able to get the named user ID
            MessageCenter.shared.predicate = NamedUserMessageCenterPredicate(namedUser: nil)

            // Current value publisher should be called with the current named user ID
            Airship.contact.namedUserIDPublisher.receive(on: DispatchQueue.main).sink { value in
                MessageCenter.shared.predicate = NamedUserMessageCenterPredicate(namedUser: value)
            }.store(in: &self.subscriptions)
        }

        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Called when the app was launched with a url. Feel free to add additional processing here,
        // but if you want the App API to support tracking app url opens, make sure to keep this call
        return ApplicationDelegateProxy.shared.application(app, open: url, options: options)
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Called when the app was launched with an activity, including Universal Links.
        // Feel free to add additional processing here, but if you want the App API to support
        // tracking app url opens, make sure to keep this call
        return ApplicationDelegateProxy.shared.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }

}

