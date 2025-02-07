//
//  TableJournalView.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/5/25.
//

import SwiftUI

struct TableJournalView: View {
	@Binding var journal: Journal
	
	var body: some View {
		VStack {
			HStack {
				Text(journal.title ?? "Error")
					.foregroundStyle(Color(hex: journal.colorHex ?? "#FF0000"))
				Text("\(journal.entries?.count ?? 0)")
					.font(.subheadline)
					.foregroundColor(.gray)
			}
			
			Text(journal.createdAt?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown Date")
				.font(.caption)
				.foregroundColor(.secondary)
		}
	}
}
