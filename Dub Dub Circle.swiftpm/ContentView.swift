import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \DeveloperEvent.date, order: .reverse, animation: .default) var events: [DeveloperEvent]
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    @State private var showEventCreationSheet = false
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            Group {
                if events.isEmpty {
                    ContentUnavailableView("Your circle looks uneventful.", systemImage: "circle.dotted.circle", description: Text("Click \(Image(systemName: "plus.circle.fill")) to add your first event."))
                        .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(events) { event in
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
            }
            .sheet(isPresented: $showEventCreationSheet) {
                NewEventView()
            }
        } detail: {
            ContentUnavailableView("No event circle selected.", systemImage: "person.2.slash.fill")
        }

    }
}
