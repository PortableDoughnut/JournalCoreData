//
//  Journal.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/6/25.
//
//

import Foundation
import SwiftData


@Model public class Journal {
    var colorHex: String?
    var createdAt: Date?
    public var id: String?
    var title: String?
    @Relationship(deleteRule: .cascade) var entries: [Entry]?
    public init() {

    }
    
}
