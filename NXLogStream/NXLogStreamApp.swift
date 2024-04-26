//
//  NXLogStreamApp.swift
//  NXLogStream
//
//  Created by Logan on 4/26/24.
//

import SwiftUI
import CocoaLumberjackSwift

@main
struct NXLogStreamApp: App {
    
    init() {
        // setup logger
        let osLogger = DDOSLogger.sharedInstance
        osLogger.logFormatter = NXLogStreamFormatter()
        DDLog.add(osLogger)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
