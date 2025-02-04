//
//  AddEditEntryView.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/3/25.
//

import SwiftUI

struct AddEditEntryView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.managedObjectContext) private var context
	
	@State private var showingImagePicker = false
	@State private var inputImage: UIImage?
	@State var titleText: String = ""
	@State var bodyText: String = ""
	@State var image: Image?
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				
				TextField("Enter Title", text: $titleText)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding(.horizontal)
					.font(.title2)
					.foregroundColor(.primary)
				
				TextEditor(text: $bodyText)
					.frame(height: 150)
					.padding(8)
					.background(Color.gray.opacity(0.1))
					.cornerRadius(8)
					.font(.body)
					.foregroundColor(.primary)
					.padding(.horizontal)
				
				VStack {
					HStack {
						Button(action: {
							showingImagePicker = true
						}) {
							Label("Pick Image", systemImage: "photo")
								.font(.headline)
								.foregroundColor(.accentColor)
						}
						.padding()
						
						Spacer()
					}
					
					if let image = image {
						GeometryReader { geometry in
							image
								.resizable()
								.scaledToFit()
								.frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
								.clipShape(RoundedRectangle(cornerRadius: 10))
								.shadow(radius: 10)
						}
						.frame(height: 200)
						.padding(.horizontal)
					}
				}
				
				HStack {
					Button("Cancel") {
						dismiss()
					}
					.foregroundColor(.red)
					.padding()
					
					Spacer()
					
					Button("Save") {
						JournalController.addEntry(
							context: context,
							title: titleText,
							body: bodyText,
							image: inputImage
						)
						dismiss()
					}
					.buttonStyle(.borderedProminent)
					.padding(.trailing)
				}
				.padding(.top, 20)
			}
			.padding(.top)
		}
		.sheet(isPresented: $showingImagePicker) {
			ImagePicker(image: $inputImage)
		}
		.onChange(of: inputImage) { _ in loadImage() }
	}
	
	func loadImage() {
		guard let inputImage = inputImage else { return }
		image = Image(uiImage: inputImage)
	}
	
	
}

//#Preview {
//    AddEditEntryView()
//}
