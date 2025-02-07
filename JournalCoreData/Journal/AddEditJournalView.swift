//
//  AddEditJournalView.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/5/25.
//

import SwiftUI
import SwiftData

struct AddEditJournalView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var context
	var journal: Journal?
	
	@State var titleText: String = ""
	@State var colorHex: String = "#FF0000"
	@State var showingColorPicker: Bool = false
	@State var currentColor: Color = .green
	
	init(journal: Journal? = nil) {
		self.journal = journal
	}
	
    var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				
				TextField("Enter Title", text: $titleText)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding(.horizontal)
					.font(.title2)
					.foregroundColor(.primary)
				
				ColorPickerView(selectedColor: $currentColor)
					.onChange(of: currentColor) {
						newValue in
						self.colorHex = newValue.toHex() ?? "#FF0000"
					}
				
				HStack {
					Button("Cancel") {
						dismiss()
					}
					.foregroundColor(.red)
					.padding()
					
					Spacer()
					
					Button("Save") {
						JournalController.addJournal(
							context: context,
							title: titleText,
							colorHex: colorHex
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
    }
}
