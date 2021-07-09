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
    @Binding var searching: Bool
    let searchingChanged: (Status) -> Void
    
    init(text: Binding<String>, isSearching: Binding<Bool>, searchingChanged: @escaping (Status) -> Void) {
        _searchText = text
        _searching = isSearching
        self.searchingChanged = searchingChanged
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(UIColor.systemGray6))
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Seach drink", text: $searchText) { startedEditing in
                    if startedEditing {
                        withAnimation {
                            searching = true
                            self.searchingChanged(.searching)
                        }
                    }
                } onCommit: {
                    withAnimation {
                        searching = false
                        self.searchingChanged(.searched)
                    }
                }
                if searching {
                    Button("Cancel") {
                        self.searchText = ""
                        self.searchingChanged(.notSearching)
                        searching = false
                        UIApplication.shared.dismissKeyboard()
                    }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    Spacer()
                }
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
    }
}


struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), isSearching: .constant(true), searchingChanged: { _ in })
            .previewLayout(.sizeThatFits)
    }
}
