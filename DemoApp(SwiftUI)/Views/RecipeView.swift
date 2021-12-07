//
//  RecipeView.swift
//  DemoApp(SwiftUI)
//
//  Created by Aline Arely Ordonez Garcia on 07/06/21.
//

import SwiftUI
import AVKit
import ImageLoader

struct RecipeView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        content
            .onAppear(perform: {
                self.viewModel.send(event: .onAppear)
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            viewModel.addOrRemove()
                        } label: {
                            favoriteButton.eraseToAnyView()
                        }
                        .accessibilityLabel("Like Button")
                        .accessibilityHint("Press Button to Add or Remove the recipe to Favorites")
                        .accessibility(sortPriority: 1)
                    }
                }
            }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return ActivityIndicator(isAnimating: true, style: .large).eraseToAnyView()
        case .error:
            return ErrorView().eraseToAnyView()
        case .loaded(let item):
            return Recipe(item).eraseToAnyView()
        }
    }
    
    private func Recipe(_ item: RecipeViewModel.Item) -> some View {
        VStack {
            VStack {
                header(item)
                    .accessibility(hidden: true)
                Text(item.title)
                    .font(.title)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Cocktail \(item.title)")
            .accessibility(sortPriority: 2)
            
            TabView {
                ScrollView {
                    ingredients(for: item)
                }
                ScrollView {
                    GenericViewCell(top: " Glass", bottom: item.glass)
                        .padding(.bottom)
                    GenericViewCell(top: " Instructions", bottom: item.instructions)
                    Spacer()
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .accessibility(sortPriority: 0)
        }.padding()
    }
    
    private func header(_ item: RecipeViewModel.Item) -> some View {
        if let video = item.video, let youTubeID = video.youtubeID {
            return WebView(url: "https://www.youtube.com/embed/\(youTubeID)")
                .frame(maxWidth: .infinity).eraseToAnyView()
        }
        
        if let url = URL(string: item.thumb) {
            return RemoteImageView(url: url, placeholder: {
                ActivityIndicator(isAnimating: true, style: .medium)
            })
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .eraseToAnyView()
        }
        
        return EmptyView().eraseToAnyView()
    }
    
    private var favoriteButton: some View {
        if viewModel.shouldAddToFavorites() {
            return Image(systemName: "heart.fill")
        } else {
            return Image(systemName: "heart")
        }
    }
    
    private func ingredients(for item: RecipeViewModel.Item) -> some View {
        return Section(header: Text(" Ingredients").font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray)
                        .foregroundColor(.white)) {
            ForEach(item.ingredients!, id:\.self) { dict in
                SectionView(dict: dict)
                    .padding(5)
            }
        }
                        .accessibilityElement(children: .combine)
    }
    
    struct SectionView : View {
        @State var dict = [String: String]()
        
        var body: some View {
            return ForEach(Array(dict.keys), id: \.self) { key in
                HStack {
                    Text(key)
                        .font(.subheadline)
                        .frame(alignment: .leading)
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(dict[key]!)")
                        .font(.subheadline)
                        .frame(alignment: .trailing)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("\(dict[key]!)")
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
    
    struct GenericViewCell: View {
        var top: String
        var bottom: String
        
        var body: some View {
            VStack(spacing: 10) {
                Text(top)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray)
                    .foregroundColor(.white)
                Text(bottom)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(top), \(bottom)")
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(viewModel: RecipeViewModel(id: "11008"))
    }
}
