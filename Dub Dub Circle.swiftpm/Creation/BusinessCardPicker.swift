//
//  BusinessCardPicker.swift
//  Dub Dub Circle
//
//  Created by Om Chachad on 2/7/25.
//

import Foundation
import SwiftUI
import PhotosUI
import VisionKit
import Vision

// Learnt Business Card VisionKit inferences from https://developer.apple.com/documentation/visionkit/structuring_recognized_text_on_a_document

struct BusinessCardPicker: View {
    @Binding var card: BusinessCard?
    
    @State private var imageData: UIImage?
    @State var photoPickerItem: PhotosPickerItem? = nil
    
    @State private var showPhotoPicker = false
    @State private var showScanBusinessCard = false
    
    var body: some View {
        Group {
            if let imageData {
                Image(uiImage: imageData)
                    .resizable()
                    .scaledToFit()
                    .scaledToFill()
                    .overlay(alignment: .bottomTrailing) {
                        pickerMenu
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .padding(5)
                            .background(.regularMaterial, in: .circle)
                            .padding(10)
                    }
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))

                if let email = card?.email {
                    LabeledContent("Email") {
                        Link(email, destination: URL(string: "mailto:\(email)")!)
                    }
                }

                if let phone = card?.phone {
                    LabeledContent("Phone", value: phone)
                }

                if let address = card?.address {
                    LabeledContent("Address", value: address)
                }

                if let urls = card?.urls, !urls.isEmpty {
                    ForEach(Array(urls.enumerated()), id: \.offset) { index, url in
                        LabeledContent("Website") {
                            Link(url.absoluteString, destination: url)
                        }
                    }
                }
            } else {
                pickerMenu
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoPickerItem)
        .onChange(of: photoPickerItem, perform: loadImage)
        .onChange(of: imageData, perform: recognizeText)
    }
    
    var pickerMenu: some View {
        Menu {
            Button {
                showPhotoPicker = true
            } label: {
                Label("Select from Photos", systemImage: "photo.on.rectangle.angled")
            }
            
            Button {
                
            } label: {
                Label("Scan Business Card", systemImage: "doc.text.viewfinder")
            }
        } label: {
            Label("Add Business Card", systemImage: "plus")
        }
    }
    
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                if case .success(let imageData) = result, let data = imageData, let uiImage = UIImage(data: data) {
                    self.imageData = uiImage
                }
            }
        }
    }
    
    private func recognizeText(from image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("Text recognition error: \(String(describing: error))")
                return
            }
            processRecognizedText(observations)
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                print("Failed to perform text recognition: \(error)")
            }
        }
    }
    
    private func processRecognizedText(_ observations: [VNRecognizedTextObservation]) {
        var fullText = ""
        for observation in observations {
            if let topCandidate = observation.topCandidates(1).first {
                fullText.append(topCandidate.string + "\n")
            }
        }
        
        DispatchQueue.main.async {
            self.card = parseTextContents(text: fullText)
        }
    }
    
    private func parseTextContents(text: String) -> BusinessCard {
        var address = ""
        var email = ""
        var name = ""
        var numbers: [String] = []
        var websites: [URL] = []
        
        var potentialNames = text.components(separatedBy: .newlines)
        
        do {
            let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
            let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
            for match in matches {
                let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
                let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
                let matchedString = String(text[matchStartIdx..<matchEndIdx])
                
                while !potentialNames.isEmpty && (matchedString.contains(potentialNames[0]) || potentialNames[0].contains(matchedString)) {
                    potentialNames.remove(at: 0)
                }
                
                switch match.resultType {
                case .address:
                    address = matchedString
                case .phoneNumber:
                    numbers.append(matchedString)
                case .link:
                    if (match.url?.absoluteString.contains("mailto"))! {
                        email = matchedString
                    } else {
                        websites.append(URL(string: matchedString)!)
                    }
                default:
                    print("\(matchedString) type:\(match.resultType)")
                }
            }
            if !potentialNames.isEmpty {
                name = potentialNames.first!
            }
        } catch {
            print("Error parsing text: \(error)")
        }
        
        return BusinessCard(imageData: imageData!.pngData()!, name: name, email: email, phone: numbers.first, address: address, urls: websites)
    }
}
 
struct VNDocumentCameraViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var scanResult: UIImage?
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = context.coordinator
        
        return documentCameraViewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scanResult: $scanResult)
    }
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        @Binding var scanResult: UIImage?
        
        init(scanResult: Binding<UIImage?>) {
            _scanResult = scanResult
        }
        
        /// Tells the delegate that the user successfully saved a scanned document from the document camera.
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            controller.dismiss(animated: true, completion: nil)
            scanResult = (0..<scan.pageCount).compactMap { scan.imageOfPage(at: $0) }.first
        }
        
        // Tells the delegate that the user canceled out of the document scanner camera.
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true, completion: nil)
        }
        
        /// Tells the delegate that document scanning failed while the camera view controller was active.
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document scanner error: \(error.localizedDescription)")
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
