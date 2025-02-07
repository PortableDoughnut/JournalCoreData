//
//  JournalsView.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/5/25.
//

import SwiftUI
import SwiftData

struct JournalsView: View {
	@Environment(\.modelContext) private var context
	
	@Query(sort: \Journal.createdAt, order: .reverse)
	private var journals: [Journal]
	
	@State private var selectedJournal: Journal?
	@State private var showingAddJournal: Bool = false
	@State private var isEditing: Bool = false
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(journals) { journal in
					NavigationLink(value: journal) {
						TableJournalView(journal: .constant(journal))
					}
					.contextMenu {
						Button("Edit") {
							selectedJournal = journal
							isEditing = true
						}
						Button("Delete", role: .destructive) {
							deleteJournal(journal)
						}
					}
				}
			}
			.navigationDestination(for: Journal.self) {
				journal in
				EntriesView(journal: .constant(journal))
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
				AddEditJournalView()
			}
			.sheet(isPresented: $isEditing) {
				if let selectedJournal = selectedJournal {
					AddEditJournalView(journal: selectedJournal)
				}
			}
			.onDisappear(perform: saveContext)
		}
	}
	
	private func deleteJournal(_ journal: Journal) {
		context.delete(journal)
		saveContext()
	}
	
	private func saveContext() {
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print("Failed to save: \(error.localizedDescription)")
			}
		}
	}
}
