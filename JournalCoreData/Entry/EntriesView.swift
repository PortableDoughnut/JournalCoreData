//
//  ContentView.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/3/25.
//

import SwiftUI
import _SwiftData_SwiftUI

struct EntriesView: View {
	@Environment(\.modelContext) private var context
	
	@State private var showingAddEntry = false
	@State private var selectedEntry: Entry?
	
	@Binding var journal: Journal
	
	@Query(sort: \Entry.createdAt, order: .reverse)
	private var entries: [Entry]
	
	var body: some View {
		let filteredEntries = entries.filter { $0.journal == journal }
		
			List {
				ForEach(filteredEntries, id: \.self) { entry in
					NavigationLink(destination: SingleEntryView(entry: entry)) {
						VStack(alignment: .leading) {
							TableEntryView(entry: entry)
						}
					}
					.contextMenu {
						Button("Edit") {
							selectedEntry = entry
						}
					}
				}
				.onDelete(perform: deleteEntry)
			}
			.navigationTitle(journal.title!)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: { showingAddEntry = true }) {
					Image(systemName: "plus")
				}
			}
		}
		.sheet(isPresented: $showingAddEntry) {
			AddEditEntryView(journal: journal)
		}
		.sheet(item: $selectedEntry) { entry in
			AddEditEntryView(entry: entry, journal: journal)
				.onDisappear(perform: saveContext)
		}
	}
	
	private func deleteEntry(at offsets: IndexSet) {
		for index in offsets {
			let entry = entries[index]
			context.delete(entry)
		}
		saveContext()
	}
	
	private func saveContext() {
		do {
			try context.save()
		} catch {
			print("Failed to save: \(error.localizedDescription)")
		}
	}
}
