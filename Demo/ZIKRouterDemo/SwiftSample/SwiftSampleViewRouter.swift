//
//  SwiftSampleViewRouter.swift
//  ZIKRouterDemo
//
//  Created by zuik on 2017/9/8.
//  Copyright © 2017 zuik. All rights reserved.
//

import UIKit
import ZIKRouter.Internal
import ZRouter

protocol SwiftSampleViewConfig {
    
}

//Custom configuration of this router.
class SwiftSampleViewConfiguration: ZIKViewMakeableConfiguration<SwiftSampleViewController>, SwiftSampleViewConfig {
    
    override func copy(with zone: NSZone? = nil) -> Any {
        return super.copy(with: zone)
    }
    var constructDestinationWithTitle: ((_ title: String) -> Void) {
        return { title in
            self.makeDestination = {
                let title = title
                let sb = UIStoryboard.init(name: "Main", bundle: nil)
                let destination = sb.instantiateViewController(withIdentifier: "SwiftSampleViewController") as! SwiftSampleViewController
                destination.title = title
                return destination
            }
        }
    }
//    var makeDestination: (() -> SwiftSampleViewController?)?
}

//Router for SwiftSampleViewController.
class SwiftSampleViewRouter: ZIKViewRouter<SwiftSampleViewController, ZIKViewMakeableConfiguration<SwiftSampleViewController>> {
    
    override class func registerRoutableDestination() {
        registerView(SwiftSampleViewController.self)
        register(RoutableView<SwiftSampleViewInput>())
        register(RoutableView<PureSwiftSampleViewInput>())
        register(RoutableViewModule<SwiftSampleViewConfig>())
        registerIdentifier("swiftSample")
    }
    
    override class func defaultRouteConfiguration() -> ZIKViewMakeableConfiguration<SwiftSampleViewController> {
        return SwiftSampleViewConfiguration()
    }
    
    override func destination(with configuration: ZIKViewMakeableConfiguration<SwiftSampleViewController>) -> SwiftSampleViewController? {
        if let make = configuration.makeDestination {
            return make()
        }
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let destination = sb.instantiateViewController(withIdentifier: "SwiftSampleViewController") as! SwiftSampleViewController
        destination.title = "Swift Sample"
        return destination
    }
    
    override func destinationFromExternalPrepared(destination: SwiftSampleViewController) -> Bool {
        if (destination.injectedAlertRouter != nil) {
            return true
        }
        return false
    }
    override func prepareDestination(_ destination: SwiftSampleViewController, configuration: ZIKViewRouteConfiguration) {
        destination.injectedAlertRouter = Router.to(RoutableViewModule<RequiredCompatibleAlertModuleInput>())
    }
}

// MARK: Declare Routable

//Declare SwiftSampleViewController is routable
extension SwiftSampleViewController: ZIKRoutableView {
}

//Declare PureSwiftSampleViewInput is routable
extension RoutableView where Protocol == PureSwiftSampleViewInput {
    init() { self.init(declaredProtocol: Protocol.self) }
}
//Declare SwiftSampleViewConfig is routable
extension RoutableViewModule where Protocol == SwiftSampleViewConfig {
    init() { self.init(declaredProtocol: Protocol.self) }
}
