//
//  ContentView.swift
//  AIVibe
//
//  Created by Sarah Zhang on 12/23/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, Welt!")

                NavigationLink(destination: SupabaseTestView()) {
                    Label("Test Supabase", systemImage: "server.rack")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: MapKitTestView()) {
                    Label("Test MapKit", systemImage: "map.fill")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: SettingsView()) {
                    Label("设置", systemImage: "gearshape.fill")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("AIVibe")
        }
    }
}

#Preview {
    ContentView()
}
