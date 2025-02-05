//
//  JournalsView.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/5/25.
//

import SwiftUI

struct JournalsView: View {
	@Environment(\.managedObjectContext) private var context
	@FetchRequest(entity: Journal.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Journal.createdAt, ascending: false)]) var journals: FetchedResults<Journal>
	
	@State private var selectedJournal: Journal?
	@State private var showingAddJournal: Bool = false
	
	var body: some View {
		NavigationView {
			List {
				ForEach(journals, id: \.objectID) {
					journal in
					NavigationLink(destination: EntriesView(journal: journal)) {
						VStack(alignment: .leading) {
							TableJournalView(journal: journal)
						}
					}
					.contextMenu {
						Button("Edit") {
							selectedJournal = journal
						}
					}
				}
				.onDelete(perform: deleteJournal)
			}
			.navigationTitle("Journals")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: { showingAddJournal = true }) {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(isPresented: $showingAddJournal) {
				AddEditJournalView().environment(\.managedObjectContext, context)
			}
			.onDisappear(perform: saveContext)
			.onAppear(perform: saveContext)
		}
	}
	
	private func deleteJournal(at offsets: IndexSet) {
		for index in offsets {
			let journal = journals[index]
			context.delete(journal)
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
