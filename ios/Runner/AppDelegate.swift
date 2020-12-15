import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let channelName = "flutterappclips/launchevents"

    private var flutterViewController: FlutterViewController {
        return self.window.rootViewController as! FlutterViewController
    }

    private lazy var eventChannel: FlutterEventChannel = {
        FlutterEventChannel(name: channelName, binaryMessenger: flutterViewController.binaryMessenger)
    }()
    private var incomingURL: URL?
    private var eventSink: FlutterEventSink?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        eventChannel.setStreamHandler(self)

        return super.application(application,
                                 didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication,
                              continue continueUserActivity: NSUserActivity,
                              restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let activityType = continueUserActivity.activityType
        guard activityType == NSUserActivityTypeBrowsingWeb,
              let url = continueUserActivity.webpageURL else { return false }

        incomingURL = url

        if let events = eventSink {
            events(url.absoluteString)
        }

        return true
    }
}

extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        
        if let url = incomingURL {
            events(url.absoluteString)
        }
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
