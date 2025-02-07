//
//  JournalController.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/3/25.
//

import SwiftUI
import SwiftData

class JournalController: ObservableObject {
	let modelContainer: ModelContainer
	@Environment(\.modelContext) private var context
	
	init() {
		do {
			modelContainer = try ModelContainer(for: Journal.self, Entry.self)
		} catch {
			fatalError("Failed to initialize SwiftData container: \(error)")
		}
	}
	
	static func addEntry(to journal: Journal, context: ModelContext, title: String, body: String, image: UIImage? = nil) {
		let newEntry = Entry()
		
		newEntry.id = UUID().uuidString
		newEntry.title = title
		newEntry.body = body
		newEntry.createdAt = Date()
		
		newEntry.journal = journal
		
		if let inputImage = image {
			newEntry.imageData = inputImage.jpegData(compressionQuality: 0.8)
		}
		
		context.insert(newEntry)
		do {
			try context.save()
		} catch {
			fatalError("Could not save entry")
		}
	}
	
	static func addJournal(context: ModelContext, title: String, colorHex: String) {
		let newJournal = Journal()
		
		newJournal.id = UUID().uuidString
		newJournal.title = title
		newJournal.createdAt = Date()
		newJournal.colorHex = colorHex
		
		context.insert(newJournal)
		try? context.save()
	}
}


extension Color {
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		
		let a, r, g, b: Double
		switch hex.count {
			case 6:
				(a, r, g, b) = (1, Double((int >> 16) & 0xFF) / 255, Double((int >> 8) & 0xFF) / 255, Double(int & 0xFF) / 255)
			case 8:
				(a, r, g, b) = (Double((int >> 24) & 0xFF) / 255, Double((int >> 16) & 0xFF) / 255, Double((int >> 8) & 0xFF) / 255, Double(int & 0xFF) / 255)
			default:
				(a, r, g, b) = (1, 0, 0, 0)
		}
		
		self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
	}
	
	func toHex(includeAlpha: Bool = false) -> String? {
		guard let components = UIColor(self).cgColor.components else { return nil }
		
		let r = Int((components[0] * 255).rounded())
		let g = Int((components[1] * 255).rounded())
		let b = Int((components[2] * 255).rounded())
		
		if includeAlpha, components.count >= 4 {
			let a = Int((components[3] * 255).rounded())
			return String(format: "#%02X%02X%02X%02X", a, r, g, b)
		} else {
			return String(format: "#%02X%02X%02X", r, g, b)
		}
	}
}
