//
//  MapPicker.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/4/25.
//

import SwiftUI
import MapKit
import Contacts

struct MapPicker: View {
    @Environment(\.dismiss) var dismiss
    /// View properties
    let garage = CLLocationCoordinate2D(
        latitude:  37.3346,
        longitude: -122.0090
    )
    
    /// Search properties
    @State private var searchQuery: String = ""
    @State private var searchResults: [MKMapItem] = []
    
    /// Map properties
    @State private var position: MapCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude:  37.3346 - 0.002,
                longitude: -122.0090
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    )
    
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var selectedResult: MKMapItem?
    
    @State private var loading = false
    
    @State private var errorLoading = false
    
    @Binding var location: Location
    
    init(location: Binding<Location>) {
        self._location = location
        
        if location.wrappedValue.coordinate != nil {
            self._position = State(initialValue: region(latitude: location.wrappedValue.latitude!, Longitude: location.wrappedValue.longitude!))
        }
    }
    
    var body: some View {
        
        ZStack {
            Map(position: $position) {
                if let selectedResult {
                    Marker(item: selectedResult)
                }
            }
            .allowsHitTesting(false)
            
            
            
            VStack {
                HStack {
                    TextField("Search", text: $searchQuery)
                        .padding(5)
                        .background(Color(uiColor: .tertiarySystemFill), in: .rect(cornerRadius: 5, style: .continuous))
                        .onSubmit {
                            search(for: searchQuery)
                        }
                    if loading {
                        ProgressView()
                    }
                }
                .padding([.top, .horizontal])
                
                Group {
                    if errorLoading && searchResults.isEmpty && !searchQuery.isEmpty {
                        VStack {
                            ContentUnavailableView("No connection? No problem.", systemImage: "network.slash")
                            
                            Button("Add **\(searchQuery)** as location?") {
                                
                            }
                            .padding()
                        }
                        .frame(maxHeight: .infinity)
                    } else if searchResults.isEmpty {
                        ContentUnavailableView("Search for a location", systemImage: "map")
                    } else {
                        Form {
                            Picker("Location", selection: $selectedResult) {
                                ForEach(searchResults, id: \.self) { result in
                                    VStack(alignment: .leading) {
                                        Text(result.placemark.name ?? "")
                                        Text(CNPostalAddressFormatter().string(from: result.placemark.postalAddress ?? CNMutablePostalAddress()).split(separator: "\n").joined(separator: ", "))
                                            .lineLimit(1)
                                            .foregroundStyle(.secondary)
                                    }
                                    .tag(result)
                                }
                            }
                            .pickerStyle(.inline)
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
                .animation(.default, value: searchResults)
            }
            .background {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .clipShape(.rect(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20, style: .continuous))
                    .shadow(radius: 10)
            }
            .frame(height: 300)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .animation(.default, value: loading)
        }
        .overlay(alignment: .top) {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(Color.primary)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.ultraThickMaterial)
                            .shadow(radius: 5)
                    }
                
                Spacer()
                
                Button("Add Location") {
                    self.location = Location(mapItem: selectedResult!)!
                    dismiss()
                }
                    .foregroundStyle(Color.accentColor)
                    .bold()
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.ultraThickMaterial)
                            .shadow(radius: 5)
                    }
                    .disabled(selectedResult == nil)
            }
            .padding()
        }
        .onChange(of: selectedResult) {
            if let result = selectedResult {
                if let location = Location(mapItem: result), location.coordinate != nil {
                    self.position = region(latitude: location.latitude!, Longitude: location.longitude!)
                }
            }
        }
        
    }
    
    /// Search method
    private func search(for query: String) {
        
        Task {
            loading = true
            let defaultRegion = region(latitude: 37.3346, Longitude: -122.0090).region
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
            request.region = visibleRegion ?? defaultRegion!
        
            let search = MKLocalSearch(request: request)
            do {
                let response = try await search.start()
                // Extract data safely within the Task
                let mapItems = response.mapItems
                let region = request.region
                
                // Update state properties outside of the actor boundary
                DispatchQueue.main.async {
                    self.searchResults = mapItems
                    self.position = .region(region)
                }
            } catch {
                errorLoading = true
                print("Search failed: \(error.localizedDescription)")
            }
            
            loading = false
        }
    }
    
    func region(latitude: Double, Longitude: Double) -> MapCameraPosition {
        return MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude:  latitude - 0.002,
                    longitude: Longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
}

extension MKLocalSearch.Response: @unchecked Sendable {}
