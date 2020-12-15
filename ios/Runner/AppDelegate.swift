import UIKit
import Flutter

enum MethodName: String {
    case getURL = "getUrl"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private let eventChannelName = "flutterappclips/events"
    private let methodChannleName = "flutterappclips/method"
    private let initialURL = URL(string: "https://flutter.memo.com/home")!

    private var flutterViewController: FlutterViewController {
        return self.window.rootViewController as! FlutterViewController
    }

    private lazy var eventChannel: FlutterEventChannel = {
        FlutterEventChannel(name: eventChannelName, binaryMessenger: flutterViewController.binaryMessenger)
    }()
    private lazy var methodChannel: FlutterMethodChannel = {
        FlutterMethodChannel(name: methodChannleName, binaryMessenger: flutterViewController.binaryMessenger)
    }()
    private var incomingURL: URL?
    private var eventSink: FlutterEventSink?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        methodChannel.setMethodCallHandler { [weak self] call, result in
            guard call.method == MethodName.getURL.rawValue else {
                result(FlutterMethodNotImplemented)
                return
            }

            guard let targetURL = self?.incomingURL else {
                result(FlutterError(code: "NOTFOUND", message: "url not found", details: nil))
                return
            }

            result(targetURL.absoluteString)
        }

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
