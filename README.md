# Dub Dub Circle

## Tell us about your app in one sentence. What specific problem is it trying to solve? Be concise.
I love attending developer conferences to connect with enthusiastic developers—but it's hard to keep track of everyone I meet: Dub Dub Circle, lets me store every developer conference I attend, make notes about the people I meet, write expressive journal entries and store images that capture the event-day spirit.

## Describe the user experience you were aiming for and why you chose the frameworks you used to achieve it. If you used AI tools, provide details about how and why they were used. 
I wanted this app to give developers—like myself—a dedicated place to store their experiences from developer conferences they’ve attended over time, while also blending into the user experience that’s familiar to them on Apple Devices. My goal was to create something that’s simple, intuitive, and delightful. 

The goal for Dub Dub Circle is to be a one-stop-shop for developers who are constantly traveling around the world and meeting new folks at different events. The primary features of this app are as follows:
1. Save the basic details about the events you’ve attended.
2. Store the details about people you met, and write notes about their apps, and the conversations you had with them.
3. Write journal entires to express yourself and remember the fun moments during these events.
4. Add photos that were taken during the event to relive these moments in the future.

I used SwiftUI because it allows for rapid iteration, native UI elements, and the ability to effortlessly adapt to all Apple Platforms in the future. Tying in beautifully with SwiftUI was SwiftData which was the persistence framework for my app. 
When adding a new event, MapKit allows for the location of the event to be stored when an internet connection is available. Otherwise, the location can be entered in manually.
With the new SubViewsOf SwiftUI Containers API, I was able to create a completely custom “Circular List” that shows the developers you met at the event wrapped around your own profile photo—switching between circular list pages has a stunning animation that truly makes you never want to stop scrolling through the app. The new Zoom Navigation Transitions make navigating the app come to life with matched animations and touch interactions when viewing attendee details. Since I have received a lot of business cards during developer events and keeping them is always a hassle, I used Vision and VisionKit to allow for business cards to be scanned and their details to be stored effortlessly. 
The PhotosUI and PhotoPicker framework allows the seamless importing of media into the app. The ScrollView transitions and alignment API allowed me to create a simple but pleasing carousel for viewing memories (photos) from the event that were saved in the app. 
To make the journaling experience more expressive, I added support for NSAttributedString with a custom UITextView that facilitates the usage of Genmojis and stickers when writing the journal entry. I did this by incorporating what I learnt in a recent Apple developer session I attended in Mumbai titled “Enhance your apps with Apple Intelligence and App Intents.”

With Dub Dub Circle, those unforgettable moments at developer conferences become impossible to forget—and effortless to relive. 

AI Disclosure: Xcode and GitHub Copilot were used to speed up the development process strictly via predictive code completion. ChatGPT was used to generate sample data for “WWDC25” that is used to demonstrate the core functionality of the app for new users. I re-assure you that all work is original and my own. Code that was used directly (or that was derived) from other sources is marked as otherwise in the playground.
