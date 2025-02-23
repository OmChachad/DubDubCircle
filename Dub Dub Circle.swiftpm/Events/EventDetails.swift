//
//  EventDetails.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/2/25.
//

import SwiftUI
import SwiftData

struct EventDetails: View {
    var event: DeveloperEvent
    
    enum ViewStyle {
        case list, circular
    }
    
    @State private var viewStyle: ViewStyle = .circular
    @State private var showNewAttendeeView = false
    
    @Namespace var namespace
    
    @State private var showMemoriesView = false
    @State private var showJournalView = false
    
    var body: some View {
        NavigationStack {
            Spacer()
            
            Text("My **\(event.title)** Circle")
                .font(.largeTitle)
            Text(event.date, style: .date)
                .font(.title2)
                .foregroundStyle(.secondary)
            
            if event.attendees.count > 0 {
                Picker("", selection: $viewStyle.animation()) {
                    
                    Image(systemName: "circle.dotted")
                        .tag(ViewStyle.circular)
                    
                    Image(systemName: "list.bullet")
                        .tag(ViewStyle.list)
                    
                }
                .pickerStyle(.segmented)
                .frame(width: 80)
            }
                
            
            switch viewStyle {
            case .list:
                Group {
                    List {
                        ForEach(event.attendees, id: \.self) { attendee in
                            AttendeeItem(attendee: attendee, namespace: namespace, viewStyle: .list)
                                .listRowBackground(Color(uiColor: .systemGray6))
                        }
                    }
                    .listStyle(.plain)
                    .background(Color(uiColor: .systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .contentMargins(.bottom, 120, for: .scrollContent)
                    .contentMargins(.bottom, 110, for: .scrollIndicators)
                    .padding()
                }
                .frame(maxHeight: .infinity, alignment: .top)
            case .circular:
                ZStack {
                    MyProfileCircle()
                        .glow()
                        .frame(width: 150, height: 150)
                    
                    CircularList {
                        ForEach(event.attendees, id: \.self) { attendee in
                            AttendeeItem(attendee: attendee, namespace: namespace, viewStyle: .circular)
                        }
                        
                        if event.attendees.count%7 != 0 || event.attendees.count == 0 {
                            ForEach((event.attendees.count%7)..<6, id: \.self) { _ in
                                Button {
                                    showNewAttendeeView = true
                                } label: {
                                    Circle()
                                        .foregroundStyle(Color(uiColor: .systemGray5))
                                }
                            }
                        }
                        
                        Button {
                            showNewAttendeeView = true
                        } label: {
                            Circle()
                                .foregroundStyle(Color(uiColor: .systemGray5))
                                .overlay(Image(systemName: "plus").font(.largeTitle).foregroundStyle(.blue))
                        }
                    }
                }
                .frame(maxHeight: 700)
                .padding(.bottom, event.attendees.count%7 == 0 && event.attendees.count != 0 ? 65 : 40)
            }
            
            Spacer()
        }
        
        .overlay(alignment: .bottom) {
            HStack(alignment: .center) {
                Button {
                    showMemoriesView = true
                } label: {
                    Label("Memories", systemImage: "photo.on.rectangle.angled.fill")
                        .foregroundStyle(AngularGradient(
                            gradient: Gradient(colors: [
                                Color(red: 250/255, green: 84/255, blue: 92/255),   // rgb(250, 84, 92)
                                Color(red: 154/255, green: 189/255, blue: 19/255),  // rgb(154, 189, 19)
                                Color(red: 103/255, green: 172/255, blue: 225/255), // rgb(103, 172, 225)
                                Color(red: 103/255, green: 172/255, blue: 225/255),  // rgb(103, 172, 225)
                                Color(red: 250/255, green: 84/255, blue: 92/255)
                            ]),
                            center: .center
                        ))
                        .font(.title)
                        .labelStyle(.iconOnly)
                        .frame(width: 65, height: 65)
                        .background(Color.white, in: .circle)
                        .bold()
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .sheet(isPresented: $showMemoriesView) {
                    MemoriesView(event: event)
                }
                
                Spacer()
                
                if (event.attendees.count%7 == 0 && event.attendees.count != 0) || viewStyle == .list{
                    Button {
                        showNewAttendeeView = true
                    } label: {
                        Label("Add Attendee", systemImage: "person.fill.badge.plus")
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(Color.accentColor.gradient, in: .rect(cornerRadius: 12.5, style: .continuous))
                            .bold()
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                }
                
                Spacer()
                
                Button {
                    showJournalView = true
                } label: {
                    Label("Journal", systemImage: "pencil.and.list.clipboard")
                        .foregroundStyle(.white)
                        .font(.title)
                        .labelStyle(.iconOnly)
                        .frame(width: 65, height: 65)
                        .background(Color.indigo.gradient, in: .circle)
                        .bold()
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
                .sheet(isPresented: $showJournalView) {
                    JournalView(event: event)
                }
            }
            .padding(5)
            .padding(.horizontal)
            .background {
                if viewStyle == .list {
                    Rectangle()
                        .fill(.clear)
                        .background(Color.primary.colorInvert())
                        .background(.ultraThinMaterial)
                        .mask {
                            Rectangle()
                                .fill(LinearGradient(colors: [.clear, .white, .white, .white, .white], startPoint: .top, endPoint: .bottom))
                        }
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea(.all)
                }
            }
            .sheet(isPresented: $showNewAttendeeView) {
                NewAttendeeView(event: event)
            }
        }
    }
}

#Preview {
    let event = DeveloperEvent(title: "WWDC", date: Date(), wasOnline: true)
    EventDetails(event: event)
}
