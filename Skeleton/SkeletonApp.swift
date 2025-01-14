//
//  SkeletonApp.swift
//  Skeleton
//
//  Created by Trey Carpenter Iii on 1/10/25.
//

import SwiftUI

@main
struct SkeletonApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                TestView()
                    .tabItem {
                        Label("Test", systemImage: "person.fill.questionmark")
                    }
                
                WeatherView()
                    .tabItem {
                        Label("Weather", systemImage: "cloud.drizzle")
                    }
            }
            
        }
    }
}
