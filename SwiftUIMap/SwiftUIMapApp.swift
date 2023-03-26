//
//  SwiftUIMapApp.swift
//  SwiftUIMap
//
//  Created by Tony on 2023-03-25.
//

import SwiftUI

@main
struct SwiftUIMapApp: App {
    
    @StateObject private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(vm)
        }
    }
}
