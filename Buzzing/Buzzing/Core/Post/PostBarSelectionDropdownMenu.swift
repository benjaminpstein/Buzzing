//
//  PostBarSelectionDropdownMenu.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/29/24.
//

import SwiftUI

struct PostBarSelectionDropdownMenu: View {
    @Binding var selectedBar: BarInfo?
    var bars: [BarInfo]
    @State private var isDropdownExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // Custom dropdown button
            Button(action: {
                withAnimation {
                    isDropdownExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedBar?.name ?? "Choose Bar")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: isDropdownExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.appPrimary)
                .cornerRadius(8)
                .shadow(radius: 4)
            }
            
            // Dropdown options
            if isDropdownExpanded {
                VStack(alignment: .leading, spacing: 4) {
                    
                    ForEach(bars, id: \.name) { bar in
                        Button(action: {
                            selectedBar = bar
                            isDropdownExpanded = true
                        }) {
                            Text(bar.name)
                                .foregroundColor(selectedBar?.name == bar.name ? Color.appLight : Color.appDark)
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(selectedBar?.name == bar.name ? Color.appPrimary : Color.appLight)
                                .cornerRadius(8)
                        }
                    }
                }
                .background(.appLight)
                .cornerRadius(8)
                .padding(4)
            }
        }
        .background(.appDark)
    }
}

#Preview {
    PostBarSelectionDropdownMenu(
        selectedBar: .constant(nil),
        bars: allBars
    )
}
