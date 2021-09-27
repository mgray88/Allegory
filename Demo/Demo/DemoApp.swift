//
//  DemoApp.swift
//  Demo
//
//  Created by Mike on 8/2/21.
//

import Allegory
import UIKit

@main
struct DemoApp: App {
//    @UIApplicationDelegateAdaptor var delegate: AppDelegate

    var body: SomeScene {
        Window {
            TabView {
                NavigationView {
                    ContentView()
                }
                .tabItem { Text("First Tab") }
                .tag(0)

                NavigationView {
                    ContentView()
                }
                .tabItem { Text("Second Tab") }
                .tag(1)
            }
        }
    }
}

//class AppDelegate: UIResponder, UIApplicationDelegate {}
