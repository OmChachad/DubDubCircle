import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \DeveloperEvent.date, order: .reverse, animation: .default) var events: [DeveloperEvent]
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    @State private var showEventCreationSheet = false
    
    var groupedEvents: [(key: String, value: [DeveloperEvent])] {
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let today = Date.now
        
        let grouped = Dictionary(grouping: events) { event in
            if calendar.isDate(event.date, equalTo: today, toGranularity: .weekOfYear) {
                return "This Week"
            } else if calendar.isDate(event.date, equalTo: today, toGranularity: .month) {
                return "This Month"
            } else {
                let eventYear = calendar.component(.year, from: event.date)
                let currentYear = calendar.component(.year, from: today)
                formatter.dateFormat = (eventYear == currentYear) ? "MMMM" : "MMMM yyyy"
                return formatter.string(from: event.date)
            }
        }
        
        return grouped.sorted { section1, section2 in
            guard let date1 = section1.value.first?.date, let date2 = section2.value.first?.date else { return false }
            return date1 > date2
        }
    }
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Group {
                if events.isEmpty {
                    ContentUnavailableView("Your circle looks uneventful.", systemImage: "circle.dotted.circle", description: Text("Click \(Image(systemName: "plus.circle.fill")) to add your first event."))
                        .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(groupedEvents, id: \.key) { section in
                            Section(header:
                                Text(section.key)
                                    .textCase(.none)
                                    .font(.headline)
                                    .fontWidth(.expanded)
                            ) {
                                ForEach(section.value) { event in
                                    NavigationLink {
                                        EventDetails(event: event)
                                            .onAppear {
                                                columnVisibility = .detailOnly
                                            }
                                    } label: {
                                        EventListItem(event: event)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Dub Dub Circle")
            .animation(.default, value: events.count)
            .safeAreaInset(edge: .bottom) {
                Button {
                    showEventCreationSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .glow()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .mask {
                            Rectangle()
                                .fill(LinearGradient(colors: [.clear, .white, .white, .white, .white], startPoint: .top, endPoint: .bottom))
                        }
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea()
                }
            }
            .sheet(isPresented: $showEventCreationSheet) {
                NewEventView()
            }
        } detail: {
            ContentUnavailableView("No event circle selected.", systemImage: "person.2.slash.fill")
        }

    }
}
