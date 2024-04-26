//
//  NXLogStream.swift
//  NXLogStream
//
//  Created by Logan on 4/26/24.
//

import Foundation
import Swifter
import CocoaLumberjackSwift

@objc class NXLogStreamServer: NSObject {
    
    @objc static let sharedServer = NXLogStreamServer()
    
    private let httpServer = HttpServer()
    private var socketSession: WebSocketSession?
    
    override init() {
        super.init()
        // log web
        httpServer["/"] = { request in
            return HttpResponse.ok(.text(logHtml))
        }
 
        // websocket
        httpServer["/logStream"] = websocket(text: { (session, text) in
            session.writeText(text)
        }, connected: { [weak self] session in
            DDLogVerbose("websocket connected")
            self?.socketSession = session
        }, disconnected: { [weak self] _ in
            DDLogVerbose("websocket disconnected")
            self?.socketSession = nil
        })
        
        do {
            let port: UInt16 = 9001
            try httpServer.start(port)
            print("Starting log server at port \(port), now open http://localhost:\(port)")
        } catch {
            print("Log Server Start Error: \(error)")
        }
    }
    
    @objc func pushLogStream(_ msg: DDLogMessage) {
        if let session = socketSession {
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("yyyy/MM/dd HH:mm:ss:SSS")
            let log = String(format: "[%@] %@", formatter.string(from: msg.timestamp), msg.message)
            session.writeText(log)
        }
    }
    
}


// MARK: - DDLog formatter
@objc class NXLogStreamFormatter: NSObject, DDLogFormatter {
    override init() {
        super.init()
        // setup log server
        _ = NXLogStreamServer.sharedServer
    }
    
    func format(message logMessage: DDLogMessage) -> String? {
        NXLogStreamServer.sharedServer.pushLogStream(logMessage)
        return logMessage.message
    }
}


fileprivate let logHtml = """
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Log stream</title>
<style>
    #logContainer {
        width: calc(100vw - 60px);
        height: calc(100vh - 60px);
        margin: auto;
        white-space: pre-wrap;
        overflow-y: scroll;
        padding: 16px;
        background-color: #232630;
        color: #eee;
        font-family: 'SF Mono', 'Fira Code', monospace;
        font-size: 15px;
    }

    #logContainer::-webkit-scrollbar {
        display: none;
    }
</style>
</head>
<body>
<div id="logContainer"></div>

<script>
    // connect WebSocket server
    const socket = new WebSocket(`ws://${window.location.host}/logStream`);

    socket.onmessage = function(event) {
        // append message
        const logContainer = document.getElementById('logContainer');
        const message = document.createElement('div');
        message.textContent = event.data;
        logContainer.appendChild(message);

        logContainer.scrollTop = logContainer.scrollHeight;
    };

    // connect close
    socket.onclose = function(event) {
        console.log('connect close');
    };

    // connect error
    socket.onerror = function(error) {
        console.error('WebSocket error:', error);
    };
</script>
</body>
</html>

"""
