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
	
	@State private var showingAddEntry = false
	@State private var selectedEntry: Entry?
	
	@ObservedObject var journal: Journal
	
	private var entries: [Entry] {
		let request: NSFetchRequest<Entry> = Entry.fetchRequest()
		request.predicate = NSPredicate(format: "journal == %@", journal)
		request.sortDescriptors = [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: false)]
		
		do {
			return try context.fetch(request)
		} catch {
			print("Failed to fetch entries: \(error.localizedDescription)")
			return []
		}
	}
	
	var body: some View {
		NavigationView {
			List {
				ForEach(entries, id: \.self) { entry in
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
			.navigationTitle("Journal Entries")
			
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: { showingAddEntry = true }) {
					Image(systemName: "plus")
				}
			}
		}
		.sheet(isPresented: $showingAddEntry) {
			AddEditEntryView(journal: journal).environment(\.managedObjectContext, context)
		}
		.sheet(item: $selectedEntry) { entry in
			AddEditEntryView(journal: journal, entry: entry)
				.environment(\.managedObjectContext, context)
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
