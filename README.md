# NXLogStream
Display live logs in the browser via websocket push streaming, Based on swifter and DDLog, using Swift language

![logstream](https://github.com/luyud/NXLogStream/assets/9164808/1e78b023-1e24-41a8-828e-3df7926b63d8)


# Usage
Add [swifter](https://github.com/httpswift/swifter) and [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack) to your project

Initialize your DDlog and add a custom formatter
```
  let osLogger = DDOSLogger.sharedInstance
  osLogger.logFormatter = NXLogStreamFormatter()
  DDLog.add(osLogger)
```
Now you can use your log method as usual
```
...
DDLogVerbose("hello world!")
...
```

Open http://localhost://9001 in your browser, and you can see the logs are displayed on the page in real time.
