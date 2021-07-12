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
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            viewModel.addOrRemove()
                        } label: {
                            favoriteButton.eraseToAnyView()
                        }
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
            header(item)
            Text(item.title)
                .font(.title)
            TabView {
                ScrollView {
                    ingredients(for: item)
                }
                VStack {
                    GenericViewCell(top: " Glass", bottom: item.glass)
                        .padding(.bottom)
                    GenericViewCell(top: " Instructions", bottom: item.instructions)
                    Spacer()
                }
            }.tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
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
        return
            Section(header: Text(" Ingredients").font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray)
                        .foregroundColor(.white)) {
                ForEach(item.ingredients!, id:\.self) { dict in
                    SectionView(dict: dict)
                        .padding(5)
                }
            }
    }
    
    struct SectionView : View {
        @State var dict = [String: String]()
        
        var body: some View {
            let keys = dict.map{$0.key}
            let values = dict.map {$0.value}
            
            return  ForEach(keys.indices) {index in
                HStack {
                    Text(keys[index])
                        .font(.subheadline)
                        .frame(alignment: .leading)
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(values[index])")
                        .font(.subheadline)
                        .frame(alignment: .trailing)
                        .foregroundColor(.secondary)
                }
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
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(viewModel: RecipeViewModel(id: "11008"))
    }
}
