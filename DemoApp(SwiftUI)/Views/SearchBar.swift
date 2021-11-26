//
//  SearchBar.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 31/05/21.
//

import SwiftUI

struct SearchBar: View {
    
    enum Status {
        case notSearching, searching, searched
    }
    
    @Binding var searchText: String
    @State var searching: Bool = false
    let searchingChanged: (Status) -> Void
    
    init(text: Binding<String>, searchingChanged: @escaping (Status) -> Void) {
        _searchText = text
        self.searchingChanged = searchingChanged
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(UIColor.systemGray6))
            HStack {
                Image(systemName: "magnifyingglass")
                    .accessibilityHidden(true)
                TextField("Seach drink", text: $searchText, onEditingChanged: {_ in
                    withAnimation {
                        self.searching = true
                        self.searchingChanged(.searching)
                    }
                }, onCommit: {
                    withAnimation {
                        self.searching = false
                        self.searchingChanged(.searched)
                    }
                })
                if searching {
                    Button("Cancel") {
                        self.searchText = ""
                        self.searchingChanged(.notSearching)
                        self.searching = false
                        UIApplication.shared.dismissKeyboard()
                    }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .accessibilityLabel("Cancel Button")
                    Spacer()
                }
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
        .accessibilityLabel("Search drink")
        .accessibilityAddTraits(AccessibilityTraits.isSearchField)
    }
}


struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), searchingChanged: { _ in })
            .previewLayout(.sizeThatFits)
    }
}
