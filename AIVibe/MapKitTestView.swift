//
//  MapKitTestView.swift
//  AIVibe
//
//  Created by Sarah Zhang on 1/2/26.
//  Day14 using Apple Mapkit

import SwiftUI
import MapKit

struct MapKitTestView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @State private var annotations: [POIAnnotation] = []
    @State private var showingAddPOI = false
    @State private var newPOIName = ""
    @State private var newPOIType = "hospital"
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isFollowingUser = true

    let poiTypes = ["hospital", "supermarket", "factory", "school", "park", "restaurant"]

    var body: some View {
        ZStack(alignment: .bottom) {
            // Map View
            Map(position: $cameraPosition) {
                UserAnnotation()

                ForEach(annotations) { annotation in
                    Annotation(annotation.name, coordinate: annotation.coordinate) {
                        VStack {
                            Image(systemName: iconForPOIType(annotation.type))
                                .foregroundColor(colorForPOIType(annotation.type))
                                .font(.title)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)

                            Text(annotation.name)
                                .font(.caption)
                                .padding(4)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            .ignoresSafeArea()

            // Control Panel
            VStack(spacing: 16) {
                // Stats
                HStack {
                    Text("Total POIs: \(annotations.count)")
                        .font(.headline)
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(10)

                    Spacer()
                }
                .padding(.horizontal)

                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        addRandomPOI()
                    }) {
                        Label("Add Random POI", systemImage: "plus.circle.fill")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        showingAddPOI.toggle()
                    }) {
                        Label("Custom POI", systemImage: "mappin.circle.fill")
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        annotations.removeAll()
                    }) {
                        Image(systemName: "trash.fill")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

                // Tracking Mode Toggle
                Button(action: toggleTrackingMode) {
                    HStack {
                        Image(systemName: isFollowingUser ? "location.fill" : "location")
                        Text(isFollowingUser ? "Tracking On" : "Tracking Off")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isFollowingUser ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("MapKit Test")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(isPresented: $showingAddPOI) {
            customPOISheet
        }
        .onAppear {
            // Add some sample POIs
            addSamplePOIs()
        }
    }

    // Custom POI Sheet
    var customPOISheet: some View {
        NavigationView {
            Form {
                Section(header: Text("POI Details")) {
                    TextField("Name", text: $newPOIName)

                    Picker("Type", selection: $newPOIType) {
                        ForEach(poiTypes, id: \.self) { type in
                            HStack {
                                Image(systemName: iconForPOIType(type))
                                Text(type.capitalized)
                            }
                            .tag(type)
                        }
                    }
                }

                Section {
                    Button("Add at Current Location") {
                        addCustomPOI()
                        showingAddPOI = false
                    }
                    .disabled(newPOIName.isEmpty)
                }
            }
            .navigationTitle("Add POI")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Cancel") {
                        showingAddPOI = false
                    }
                }
            }
        }
    }

    // MARK: - Functions

    func addSamplePOIs() {
        // Add some sample POIs around San Francisco
        let samples = [
            POIAnnotation(id: UUID().uuidString, name: "General Hospital", type: "hospital",
                         coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
            POIAnnotation(id: UUID().uuidString, name: "Whole Foods", type: "supermarket",
                         coordinate: CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094)),
            POIAnnotation(id: UUID().uuidString, name: "Tech Factory", type: "factory",
                         coordinate: CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4294))
        ]
        annotations.append(contentsOf: samples)
    }

    func addRandomPOI() {
        let randomType = poiTypes.randomElement() ?? "hospital"
        let randomLat = region.center.latitude + Double.random(in: -0.02...0.02)
        let randomLong = region.center.longitude + Double.random(in: -0.02...0.02)

        let newPOI = POIAnnotation(
            id: UUID().uuidString,
            name: "\(randomType.capitalized) \(annotations.count + 1)",
            type: randomType,
            coordinate: CLLocationCoordinate2D(latitude: randomLat, longitude: randomLong)
        )

        annotations.append(newPOI)
    }

    func addCustomPOI() {
        let newPOI = POIAnnotation(
            id: UUID().uuidString,
            name: newPOIName,
            type: newPOIType,
            coordinate: region.center
        )

        annotations.append(newPOI)
        newPOIName = ""
    }

    func toggleTrackingMode() {
        isFollowingUser.toggle()
        if isFollowingUser {
            cameraPosition = .userLocation(fallback: .automatic)
        } else {
            cameraPosition = .region(region)
        }
    }

    func iconForPOIType(_ type: String) -> String {
        switch type {
        case "hospital": return "cross.circle.fill"
        case "supermarket": return "cart.fill"
        case "factory": return "building.2.fill"
        case "school": return "book.fill"
        case "park": return "tree.fill"
        case "restaurant": return "fork.knife"
        default: return "mappin.circle.fill"
        }
    }

    func colorForPOIType(_ type: String) -> Color {
        switch type {
        case "hospital": return .red
        case "supermarket": return .green
        case "factory": return .orange
        case "school": return .blue
        case "park": return .mint
        case "restaurant": return .purple
        default: return .gray
        }
    }
}

// MARK: - POI Annotation Model
struct POIAnnotation: Identifiable {
    let id: String
    let name: String
    let type: String
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    NavigationView {
        MapKitTestView()
    }
}
