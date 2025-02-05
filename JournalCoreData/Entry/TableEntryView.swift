//
//  TableEntryView.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/5/25.
//

import SwiftUI

struct TableEntryView: View {
	var entry: Entry
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(entry.title ?? "Untitled")
				.font(.headline)
			Text(entry.body ?? "No content")
				.font(.subheadline)
				.foregroundColor(.gray)
			Text(entry.createdAt?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown Date")
				.font(.caption)
				.foregroundColor(.secondary)
		}
	}
}
