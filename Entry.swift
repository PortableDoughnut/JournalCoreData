//
//  Entry.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/6/25.
//
//

import Foundation
import SwiftData


@Model public class Entry {
    var body: String?
    var createdAt: Date?
    public var id: String?
    var imageData: Data?
    var title: String?
    var journal: Journal?
    public init() {

    }
    
}
