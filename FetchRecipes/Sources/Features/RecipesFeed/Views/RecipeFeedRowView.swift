//
//  RecipeFeedRowView.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

import SwiftUI
import RemoteImage

struct RecipeFeedRowView: View {
    @Environment(\.recipeVideoDidPress) private var recipeVideoDidPress
    @Environment(\.recipeDetailsDidPress) private var recipeDetailsDidPress
    
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: Spacing.s1) {
            RemoteImage(
                urlStr: recipe.photoUrlSmall ?? "",
                resizeMethod: .fillcrop,
                quality: .high,
                placeholder: .color(.gray)
            )
            .aspectRatio(1, contentMode: .fit)
            
            description

            Spacer(minLength: 0)
        }
        .frame(height: Spacing.s12)
        .dynamicTypeSize((.xSmall)...(.large))
    }
    
    private var description: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(recipe.name)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.bottom, Spacing.half)
            
            Text(Ln.cuisineName(recipe.cuisine))
                .font(.subheadline)
                .lineLimit(1)

            Spacer(minLength: 0)
            
            navigationButtonsView
        }
    }
    
    private var navigationButtonsView: some View {
        HStack(spacing: Spacing.s3) {
            if let videoUrlString = recipe.youtubeUrl,
               let videoUrl = URL(string: videoUrlString) {
                button(icon: "video.square") {
                    recipeVideoDidPress(videoUrl)
                }
                .foregroundStyle(Color.orange)
            }
            if let sourceURLString = recipe.sourceUrl,
               let sourceURL = URL(string: sourceURLString){
                button(icon: "info.square") {
                    recipeDetailsDidPress(sourceURL)
                }
                .foregroundStyle(Color.blue)
            }
        }
    }
    
    private func button(icon: String, action: @escaping () -> ()) -> some View {
        Image(systemName: icon)
            .font(.title2.weight(.light))
            .buttonWrapped(action: action)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 10) {
        RecipeFeedRowView(
            recipe: .init(
                uuid: "0",
                cuisine: "Japanese",
                name: "Sushi",
                photoUrlLarge: MockImage.foodSushi,
                photoUrlSmall: MockImage.foodSushi,
                sourceUrl: nil,
                youtubeUrl: nil
            )
        )
        RecipeFeedRowView(
            recipe: .init(
                uuid: "1",
                cuisine: "American",
                name: "Beef and Cheese Frittata on the hot grill and long recipe name",
                photoUrlLarge: MockImage.foodBeef,
                photoUrlSmall: MockImage.foodBeef,
                sourceUrl: "https://www.bbcgoodfood.com/recipes/banana-pancakes",
                youtubeUrl: nil
            )
        )
        RecipeFeedRowView(
            recipe: .init(
                uuid: "2",
                cuisine: "Canadian",
                name: "Canadian Butter Tarts",
                photoUrlLarge: MockImage.foodSaladChicken,
                photoUrlSmall: MockImage.foodSaladChicken,
                sourceUrl: nil,
                youtubeUrl: "https://www.youtube.com/watch?v=WUpaOGghOdo"
            )
        )
        RecipeFeedRowView(
            recipe: .init(
                uuid: "3",
                cuisine: "French cuisine with very long recipe name which will not fit the label",
                name: "Chinon Apple Tarts with very long recipe name which will never fit any label we will have",
                photoUrlLarge: MockImage.foodFish,
                photoUrlSmall: MockImage.foodFish,
                sourceUrl: "https://www.bbcgoodfood.com/recipes/chinon-apple-tarts",
                youtubeUrl: "https://www.youtube.com/watch?v=5dAW9HQgtCk"
            )
        )
    }
    .mockImageFetcher()
}
#endif
