//
//  FeedHeaderView.swift
//  Buzzing
//
//  Created by Benjamin Stein on 11/12/24.
//

import SwiftUI

struct FeedHeaderView: View {
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            Text("What's Buzzing?")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top)
                .foregroundColor(Color.appLight)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack() {
                ZStack{
                    tabButton(title: "By New", tag: 1)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.appPrimary, lineWidth: 2)
                        .frame(height: 30)
                        .padding(.horizontal, 18)
                }
                ZStack{
                    tabButton(title: "By Bar", tag: 2)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.appPrimary, lineWidth: 2)
                        .frame(height: 30)
                        .padding(.horizontal, 18)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 8)
            .padding(.top, -5)
            .background(Color.appDark)
        }
        .background(Color.appDark)
    }

    func tabButton(title: String, tag: Int) -> some View {
        Button(action: {
            withAnimation {
                selectedTab = tag
            }
        }) {
            ZStack {
                // Rounded rectangle outline for the selected tab
                if selectedTab == tag {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.appPrimary)
                        .frame(height: 30)
                        .padding(.horizontal, 18)
                }
                
                // Tab title
                Text(title)
                    .foregroundColor(Color.appLight)
                    .fontWeight(selectedTab == tag ? .bold : .regular)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    FeedHeaderView(selectedTab: .constant(1))
}
