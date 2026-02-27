//
//  Onboarding.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/24/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct Onboarding: View {
    @Environment(\.modelContext) var context
    @Query(filter: #Predicate<Contact> { profile in
        profile.isMyProfile == true
    }) var profiles: [Contact]
    
    var body: some View {
        TransitioningPageView(rotationEnabled: false) {
            PageOne()
            
            if let profile = profiles.first {
                PageTwo(profile: profile)
                PageThree(profile: profile)
                PageFour(profile: profile)
                PageFive(profile: profile)
                PageSix()
            }
        }
        .padding()
        .onAppear {
            if profiles.isEmpty {
                let newProfile = Contact(isMyProfile: true, name: "", notes: "", developmentPlatforms: [], developmentFrameworks: [])
                context.insert(newProfile)
                try? context.save()
            }
        }
    }
    
    struct PageOne: View {
        @State private var revealed = false
        
        var body: some View {
            VStack {
                Spacer()
                
                Text("Welcome to\nDub Dub Circle")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .fontWidth(.expanded)
                
                Spacer()
                
                if revealed {
                    Group {
                        Image("Icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 200*2/9, style: .continuous))
                            .glow()
                        
                        Spacer()
                        
                        Text("The best way to remember your favorite prople and memories from developer events.")
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .transition(.blurReplace)
                }
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        revealed = true
                    }
                }
            }
        }
    }
    
    struct PageTwo: View {
        @Bindable var profile: Contact
        var body: some View {
            VStack {
                Spacer()
                
                Text("What's your name?")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .fontWidth(.expanded)
                
                TextField("Name", text: $profile.name)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                Spacer()
            }
        }
    }
    
    struct PageThree: View {
        @Bindable var profile: Contact
        
        var body: some View {
            VStack {
                Spacer()
                
                Text("What platforms do you develop for?")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .fontWidth(.expanded)
                
                HStack {
                    ForEach(Contact.Platform.allCases, id: \.self) { platform in
                        Image(systemName: platform.iconName)
                            .symbolEffect(.bounce, value: profile.developmentPlatforms.contains(platform))
                            .imageScale(.large)
                            .foregroundStyle(Color.accentColor)
                            .opacity(profile.developmentPlatforms.contains(platform) ? 1 : 0.3)
                            .onTapGesture {
                                withAnimation {
                                    if profile.developmentPlatforms.contains(platform) {
                                        profile.developmentPlatforms.removeAll { $0 == platform }
                                    } else {
                                        profile.developmentPlatforms.append(platform)
                                    }
                                }
                            }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
    
    struct PageFour: View {
        @Bindable var profile: Contact
        
        var body: some View {
            VStack {
                Spacer()
                
                Text("What frameworks do you use?")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .fontWidth(.expanded)
                
                HStack {
                    ForEach(Contact.DevelopmentFramework.allCases, id: \.self) { framework in
                        Text(framework.rawValue)
                            .fontWidth(.expanded)
                            .foregroundStyle(Color.accentColor)
                            .opacity(profile.developmentFrameworks.contains(framework) ? 1 : 0.3)
                            .onTapGesture {
                                withAnimation {
                                    if profile.developmentFrameworks.contains(framework) {
                                        profile.developmentFrameworks.removeAll { $0 == framework }
                                    } else {
                                        profile.developmentFrameworks.append(framework)
                                    }
                                }
                            }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
    
    // Page Five for uploading profile photo
    struct PageFive: View {
        @Bindable var profile: Contact
        
        @State var photoPickerItem: PhotosPickerItem? = nil
        @State private var showPhotoPicker = false
        
        var body: some View {
            VStack {
                Spacer()
                
                Text("Upload a profile photo")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .fontWidth(.expanded)
                
                Group {
                    if let profilePhotoData = profile.imageData {
                        Image(uiImage: UIImage(data: profilePhotoData)!)
                            .resizable()
                             .scaledToFit()
                             .scaledToFill()
                             .frame(width: 150, height: 175)
                             .clipShape(Circle())
                             .glow()
                    } else {
                        Image(systemName: "person.fill.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.secondary)
                            .offset(x: 5, y: 5)
                            .padding(30)
                            .frame(width: 150, height: 150)
                            .background(Color(.systemGray5), in: .circle)
                    }
                }
                .padding(5)
                .onTapGesture {
                    showPhotoPicker = true
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem)
                .onChange(of: photoPickerItem) {
                    if let photoPickerItem {
                        Task {
                            profile.imageData = try? await photoPickerItem.loadTransferable(type: Data.self)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
    
    struct PageSix: View {
        @Environment(\.dismiss) var dismiss
        @Environment(\.modelContext) var context
        
        var body: some View {
            VStack {
                Spacer()
                
                Text("You are all set!")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .fontWidth(.expanded)
                
                Spacer()
                
                Button {
                    dismiss()
                    addSampleData()
                } label: {
                    Text("Start Exploring")
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(.blue, in: .capsule)
                }
                
                Spacer()
                    .frame(height: 50)
            }
        }
        
        
        
        func addSampleData() {
            func makeDate(
                year: Int,
                month: Int,
                day: Int,
                hour: Int = 0,
                minute: Int = 0
            ) -> Date {
                var components = DateComponents()
                components.year = year
                components.month = month
                components.day = day
                components.hour = hour
                components.minute = minute
                return Calendar.current.date(from: components)!
            }
            
            // MARK: - Location
            
            let appleParkLocation = Location(
                name: "Apple Park",
                address: "One Apple Park Way, Cupertino, CA 95014",
                latitude: 37.3349,
                longitude: -122.0090
            )

            // Sample attendees (Apple execs, engineers, and community figures)
            
            // MARK: - Attendees
            
            let attendees: [Contact] = [
                // https://asiaone.co.in/tim-cook/
                Contact(imageData: UIImage(named: "Tim Cook")?.pngData() ?? Data(), name: "Tim Cook", email: "tim@apple.com", notes: "CEO of Apple. Had a brief conversation about the future of AI in iOS.", companyName: "Apple", city: "Cupertino, CA", events: [], developmentPlatforms: [.mac, .iphone], developmentFrameworks: [.swiftUI]),

                // https://in.pinterest.com/pin/craig-federighi--623818985915386694/
                Contact(imageData: UIImage(named: "Craig Federighi")?.pngData() ?? Data(), name: "Craig Federighi", email: "craig@apple.com", notes: "Senior VP of Software Engineering. He cracked a joke about Xcode crashing mid-demo.", companyName: "Apple", city: "Cupertino, CA", events: [], developmentPlatforms: [.iphone, .mac], developmentFrameworks: [.swiftUI, .uiKit]),

                // https://www.livemint.com/mint-lounge/business-of-life/apple-greg-joswiak-generative-ai-vision-pro-interview-111709896148759.html
                Contact(imageData: UIImage(named: "Greg Joswiak")?.pngData() ?? Data(), name: "Greg Joswiak", email: "joz@apple.com", notes: "VP of Marketing. Shared insights on Apple's vision for developers.", companyName: "Apple", city: "Cupertino, CA", events: [], developmentPlatforms: [.iphone, .ipad], developmentFrameworks: [.swiftUI]),
                
                
                // https://app.boardroominsiders.com/skinny-profiles/apple-inc-susan-prescott
                Contact(imageData: UIImage(named: "Susan Prescott")?.pngData() ?? Data(), name: "Susan Prescott", email: "susan@apple.com", notes: "VP of Developer Relations. Encouraged me to apply for the Swift Student Challenge.", companyName: "Apple", city: "Cupertino, CA", events: [], developmentPlatforms: [.mac, .iphone], developmentFrameworks: [.swiftUI]),
                
                // https://x.com/twostraws
                Contact(imageData: UIImage(named: "Paul Hudson")?.pngData() ?? Data(), name: "Paul Hudson", email: "paul@hackingwithswift.com", notes: "Runs Hacking with Swift. Shared tips on SwiftData.", companyName: "Hacking with Swift", city: "London, UK", events: [], developmentPlatforms: [.iphone, .ipad], developmentFrameworks: [.swiftUI]),
                
                // https://x.com/jsngr
                Contact(imageData: UIImage(named: "Jordan Singer")?.pngData() ?? Data(), name: "Jordan Singer", email: "singer@hey.com", notes: "Indie Dev & UI Designer. Working on an AI-powered SwiftUI design tool.", companyName: "iBuildMyIdeas", city: "Seattle, WA", events: [], developmentPlatforms: [.iphone, .mac], developmentFrameworks: [.swiftUI]),
                
                // https://x.com/sdw
                Contact(imageData: UIImage(named: "Sebastiaan de With")?.pngData() ?? Data(), name: "Sebastiaan de With", email: "seb@luxoptics.com", notes: "Designer of Halide. Discussed camera APIs.", companyName: "Lux Optics", city: "San Francisco, CA", events: [], developmentPlatforms: [.iphone, .ipad], developmentFrameworks: [.swiftUI]),
                
                // https://mastodon.social/@stroughtonsmith/with_replies
                Contact(imageData: UIImage(named: "Steve Troughton-Smith")?.pngData() ?? Data(), name: "Steve Troughton-Smith", email: "steve@highcaffeinecontent.com", notes: "iOS Dev & Reverse Engineer. Had great insights on Vision Pro development.", companyName: "High Caffeine Content", city: "Dublin, Ireland", events: [], developmentPlatforms: [.vision, .mac], developmentFrameworks: [.swiftUI, .other]),
                
                // https://x.com/viticci
                Contact(imageData: UIImage(named: "Federico Viticci")?.pngData() ?? Data(), name: "Federico Viticci", email: "federico@macstories.net", notes: "Founder of MacStories. Deep discussion on iPadOS & Shortcuts.", companyName: "MacStories", city: "Rome, Italy", events: [], developmentPlatforms: [.ipad, .iphone], developmentFrameworks: [.swiftUI]),
                
                
                // https://simonbs.dev
                Contact(imageData: UIImage(named: "Simon Støvring")?.pngData() ?? Data(), name: "Simon Støvring", email: "simon@scriptable.app", notes: "Creator of Scriptable & DataJar. Discussed automation.", companyName: "Scriptable", city: "Copenhagen, Denmark", events: [], developmentPlatforms: [.iphone, .ipad], developmentFrameworks: [.swiftUI, .uiKit]),
                
                
                // https://www.linkedin.com/in/christianselig/?originalSubdomain=ca
                Contact(imageData: UIImage(named: "Christian Selig")?.pngData() ?? Data(), name: "Christian Selig", email: "chris@apolloapp.io", notes: "Built Apollo. Shared experiences on App Store policies.", companyName: "Apollo", city: "Toronto, Canada", events: [], developmentPlatforms: [.iphone, .mac], developmentFrameworks: [.swiftUI]),
                
                // https://rryam.com/rudrank
                Contact(imageData: UIImage(named: "Rudrank Riyam")?.pngData() ?? Data(), name: "Rudrank Riyam", email: "rudrank@swiftindie.com", notes: "Swift MusicKit expert. Discussed building music apps.", city: "Gurugram, India", events: [], developmentPlatforms: [.iphone, .mac], developmentFrameworks: [.swiftUI]),
                
                // https://www.linkedin.com/in/mufasayc/
                Contact(imageData: UIImage(named: "Mustafa Yusuf")?.pngData() ?? Data(), name: "Mustafa Yusuf", email: "mustafa@msquarelabs.com", notes: "Vision Pro developer. Showed an incredible SwiftData project.", companyName: "Chirper", city: "Mumbai, India", events: [], developmentPlatforms: [.vision, .iphone], developmentFrameworks: [.swiftUI, .other])
            ]
            
        
            // MARK: - Event
            
            let wwdc26Event = DeveloperEvent(
                title: "WWDC26",
                attendees: attendees,
                memories: [],
                journalEntries: [],
                date: makeDate(year: 2026, month: 6, day: 8),
                location: appleParkLocation
            )
            
            // MARK: - Memories
            
            wwdc26Event.memories = [
                
                // Image source: https://www.indiatoday
                // Source: https://developer.apple.com/events/
                Memory(imageData: UIImage(named: "Run")?.pngData() ?? Data(), date: makeDate(year: 2026, month: 6, day: 8, hour: 10), description: "Craig Federighi’s epic keynote run."),
                
                // Source: https://developer.apple.com/events/
                Memory(imageData: UIImage(named: "Session")?.pngData() ?? Data(), date: makeDate(year: 2026, month: 6, day: 8, hour: 14), description: "Developer Session."),
                
                // Image source: https://wallpapers.com/wallpapers/apple-park-visitor-center-sunset-0zdbuytq2xfagvk9.html
                Memory(imageData: UIImage(named: "Sunset")?.pngData() ?? Data(), date: makeDate(year: 2026, month: 6, day: 8, hour: 19), description: "Apple Park Visitor Center at sunset.")
            ]
            
            // MARK: - Journal Entries
            
            wwdc26Event.journalEntries = [
                JournalEntry(event: wwdc26Event, title: "Keynote Highlights", journalContents: AttributedString("Tim Cook opened WWDC26 with an inspiring message. Craig demoed iOS 20 — mind-blowing improvements."), date: makeDate(year: 2026, month: 6, day: 8, hour: 9), relatedAttendees: [attendees[0], attendees[1]]),
                
                JournalEntry(event: wwdc26Event, title: "Chat with Paul Hudson", journalContents: AttributedString("Met Paul at the SwiftUI lab. Got great SwiftData advice."), date: makeDate(year: 2026, month: 6, day: 9, hour: 11), relatedAttendees: [attendees[4]]),
                
                JournalEntry(event: wwdc26Event, title: "MusicKit Workshop", journalContents: AttributedString("Attended a fantastic MusicKit session with Rudrank."), date: makeDate(year: 2026, month: 6, day: 10, hour: 15), relatedAttendees: [attendees[11]]),
                
                JournalEntry(event: wwdc26Event, title: "Sunset Reflection", journalContents: AttributedString("Ended the day walking around Apple Park. The best part of WWDC isn’t just the tech — it’s the people."), date: makeDate(year: 2026, month: 6, day: 8, hour: 20), relatedAttendees: [])
            ]
            
            context.insert(wwdc26Event)
            try? context.save()
        }
    }
    
}
