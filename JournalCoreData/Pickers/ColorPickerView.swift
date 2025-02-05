//
//  ColorPicker.swift
//  JournalCoreData
//
//  Created by Gwen Thelin on 2/5/25.
//

import SwiftUI

struct ColorPickerView: View {
	@Binding var selectedColor: Color
	
	var body: some View {
		VStack {
			ColorPicker("Pick a color", selection: $selectedColor)
				.padding()
			
			Text("Selected Color")
				.foregroundColor(selectedColor)
				.font(.headline)
				.padding()
		}
	}
}
