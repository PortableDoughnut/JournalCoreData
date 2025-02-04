//
//  SingleEntryView.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/3/25.
//

import SwiftUI

struct SingleEntryView: View {
	var entry: Entry
	
	var relativeDateFormatter: RelativeDateTimeFormatter {
		let formatter = RelativeDateTimeFormatter()
		formatter.dateTimeStyle = .numeric
		return formatter
	}
	
	var body: some View {
		VStack(spacing: 16) {
			Text(entry.title ?? "Title")
				.font(.largeTitle)
				.fontWeight(.bold)
				.padding(.top)
			
			Text(entry.body ?? "Body")
				.font(.body)
				.padding(.horizontal)
			
			if let createdAt = entry.createdAt, let relativeString = relativeDateFormatter.string(for: createdAt) {
				Text(relativeString)
					.font(.subheadline)
					.foregroundColor(.gray)
			}
			
			if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
				Image(uiImage: uiImage)
					.resizable()
					.scaledToFit()
					.frame(height: 200)
					.cornerRadius(8)
					.padding()
			}
			
			Spacer()
		}
		.padding()
	}
}
