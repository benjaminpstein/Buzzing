//
//  ByBarFeedDropdownMenuView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/13/24.
//

import SwiftUI

struct ByBarFeedDropdownMenuView: View {
    @Binding var selectedBar: BarInfo?
    var bars: [BarInfo]
    @State private var isDropdownExpanded = true

    // Option to view all bars
    var allOption: String { "All Bars" }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Custom dropdown button
            Button(action: {
                withAnimation {
                    isDropdownExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedBar?.name ?? allOption)
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
                    // Option to view all bars
                    Button(action: {
                        selectedBar = nil
                        isDropdownExpanded = false
                    }) {
                        Text(allOption)
                            .foregroundColor(selectedBar == nil ? Color.appLight : Color.appDark)
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(selectedBar == nil ? Color.appPrimary : Color.appLight)
                            .cornerRadius(8)
                    }
                    
                    // List of bars
                    ForEach(bars, id: \.name) { bar in
                        Button(action: {
                            selectedBar = bar
                            isDropdownExpanded = false
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
        .padding(.horizontal)
        .background(.appDark)
    }
}
#Preview {
    ByBarFeedDropdownMenuView(
        selectedBar: .constant(nil),
        bars: allBars
    )
}
