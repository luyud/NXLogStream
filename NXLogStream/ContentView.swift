//
//  ContentView.swift
//  NXLogStream
//
//  Created by Logan on 4/26/24.
//

import SwiftUI
import CocoaLumberjackSwift

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: {
                let logs = ["hello world!", "Log whith new line\nthis is second line", "random log looooooooong"]
                DDLogVerbose("\(logs[Int(arc4random()) % 3])")
            }, label: {
                Text("Push Log")
            })
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
