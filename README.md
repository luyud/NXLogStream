# NXLogStream
Display live logs in the browser via websocket push streaming, Based on swifter and DDLog, using Swift language

<img width="958" alt="logstream" src="https://github.com/luyud/NXLogStream/assets/9164808/4fb22d54-44e4-4392-96a7-cabda5fdf87c">

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
