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
    }
    
}
