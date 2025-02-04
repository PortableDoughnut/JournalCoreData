//
//  ContentView.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/3/25.
//

import SwiftUI
import CoreData

struct EntriesView: View {
	@Environment(\.managedObjectContext) private var context
	@FetchRequest(entity: Entry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: false)]) private var entries: FetchedResults<Entry>
	
	@State private var showingAddEntry = false
	
	var body: some View {
		NavigationView {
			List {
				ForEach(entries, id: \Entry.objectID) { entry in
					NavigationLink(destination: SingleEntryView(entry: entry)) {
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
				.onDelete(perform: deleteEntry)
			}
			.navigationTitle("Journal Entries")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: { showingAddEntry = true }) {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(isPresented: $showingAddEntry) {
				AddEditEntryView().environment(\.managedObjectContext, context)
			}
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
#Preview {
	EntriesView()
}
