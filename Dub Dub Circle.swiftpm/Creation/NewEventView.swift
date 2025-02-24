//
//  NewEventView.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/4/25.
//

import SwiftUI
import MapKit

struct NewEventView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var wasOnline = false
    @State private var coordinates = 0.0
    
    @State private var showMapPicker = false
    @State private var location: Location = Location(name: "Apple Park", address: "One Apple Park", latitude: 37.3346, longitude: -122.0090)
    
    var existingEvent: DeveloperEvent?
    
    init(editing existingEvent: DeveloperEvent? = nil) {
        self.existingEvent = existingEvent
        
        if let event = existingEvent {
            _title = State(initialValue: event.title)
            _date = State(initialValue: event.date)
            _wasOnline = State(initialValue: event.wasOnline)
            _location = State(initialValue: event.location ?? Location(name: "Apple Park", address: "One Apple Park", latitude: 37.3346, longitude: -122.0090))
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date)
                }
                
                Section("Location") {
                    if !wasOnline {
                        if let coordinate = location.coordinate {
                            Map(position: .constant(region(latitude: location.latitude!, Longitude: location.longitude!))) {
                                Marker(location.name, coordinate: coordinate)
                            }
                            .allowsHitTesting(false)
                            .frame(height: 200)
                            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        
                        HStack {
                            Label {
                                Text(location.name)
                            } icon: {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundStyle(.blue)
                            }
                            
                            Spacer()
                            
                            Button("Change", systemImage: "arrow.trianglehead.2.clockwise.rotate.90") {
                                showMapPicker = true
                            }
                            .labelStyle(.iconOnly)
                        }
                        .sheet(isPresented: $showMapPicker) {
                            MapPicker(location: $location)
                        }
                    }
                    
                    Toggle("Online Event", isOn: $wasOnline)
                }
            }
            .navigationTitle(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "New Event" : title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let event = existingEvent {
                            event.title = title
                            event.date = date
                            event.wasOnline = wasOnline
                            event.location = location
                        } else {
                            if wasOnline {
                                let event = DeveloperEvent(title: title, date: date, wasOnline: wasOnline)
                                modelContext.insert(event)
                            } else {
                                let event = DeveloperEvent(title: title, date: date, location: location)
                                modelContext.insert(event)
                            }
                        }
                        
                        try? modelContext.save()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
            }
        }
    }
    
    func region(latitude: Double, Longitude: Double) -> MapCameraPosition {
        return MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude:  latitude,
                    longitude: Longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
            )
        )
    }

}

#Preview {
    VStack {
        
    }
    .sheet(isPresented: .constant(true)) {
        NewEventView()
    }
}
