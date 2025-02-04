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
	
	static func addEntry(context: NSManagedObjectContext, title: String, body: String, image: UIImage? = nil) {
		let newEntry = Entry(context: context)
		
		newEntry.id = UUID().uuidString
		newEntry.title = title
		newEntry.body = body
		newEntry.createdAt = Date()
		
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
}
