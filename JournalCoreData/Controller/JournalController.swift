//
//  JournalController.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/3/25.
//

import SwiftUI
import CoreData

class JournalController: ObservableObject {
	
	let container: NSPersistentContainer
	static var shared = JournalController()
	
	init() {
		container = NSPersistentContainer(name: "JournalCoreData")
		container.loadPersistentStores { (storeDescription, error) in
			if let error = error as NSError? {
				print("Unresolved error: \(error), \(error.userInfo)")
			}
		}
	}
	
	static func addEntry(to journal: Journal, context: NSManagedObjectContext, title: String, body: String, image: UIImage? = nil) {
		let newEntry = Entry(context: context)
		
		newEntry.id = UUID().uuidString
		newEntry.title = title
		newEntry.body = body
		newEntry.createdAt = Date()
		
		newEntry.journal = journal
		
		if let inputImage = image {
			newEntry.imageData = inputImage.jpegData(compressionQuality: 0.8)
		}
		
		do {
			try context.save()
			print("Entry saved successfully!")
		} catch {
			let nsError = error as NSError
			print("Unresolved error \(nsError), \(nsError.userInfo)")
		}
	}
	
	static func addJournal(context: NSManagedObjectContext, title: String, colorHex: String) {
		let newJournal = Journal(context: context)
		
		newJournal.id = UUID().uuidString
		newJournal.title = title
		newJournal.createdAt = Date()
		newJournal.colorHex = colorHex
		
		do {
			try context.save()
			print("Entry saved successfully!")
		} catch {
			let nsError = error as NSError
			print("Unresolved error \(nsError), \(nsError.userInfo)")
		}
	}
}

extension Journal {
	var entriesArray: [Entry] {
		guard let all = entries?.allObjects as? [Entry] else { return [] }
		return Array(all)
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
