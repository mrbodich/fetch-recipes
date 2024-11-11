//
//  Recipe+Mocks.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/9/24.
//

#if DEBUG
extension MockData {
    static func mockRecipes() -> [Recipe] {
        [
            .init(
                uuid: "2b9003b5-000d-445a-8b19-bbaed1b9f851",
                cuisine: "British",
                name: "Spotted Dick",
                photoUrlLarge: MockImage.foodBeef,
                photoUrlSmall: MockImage.foodBeef,
                sourceUrl: "https://www.bbcgoodfood.com/recipes/2686661/spotted-dick",
                youtubeUrl: "https://www.youtube.com/watch?v=fu15XOF-ros"
            ),
            .init(
                uuid: "ee112b29-829b-45c6-8c3d-3effe739c9f0",
                cuisine: "British",
                name: "Sticky Toffee Pudding",
                photoUrlLarge: MockImage.foodFish,
                photoUrlSmall: MockImage.foodFish,
                sourceUrl: "https://www.bbc.co.uk/food/recipes/marys_sticky_toffee_41970",
                youtubeUrl: "https://www.youtube.com/watch?v=Wytv3bjqJII"
            ),
            .init(
                uuid: "7365af2d-ab0b-4bab-a94f-462ffd752a09",
                cuisine: "British",
                name: "Awesome Sticky Toffee Pudding Ultimate",
                photoUrlLarge: MockImage.foodSushi,
                photoUrlSmall: MockImage.foodSushi,
                sourceUrl: "https://www.youtube.com/watch?v=Wytv3bjqJII",
                youtubeUrl: "https://www.youtube.com/watch?v=hKq6RbxJHBo"
            ),
            .init(
                uuid: "d2251700-21da-4931-9dc6-4d273643f5c7",
                cuisine: "British",
                name: "Strawberry Rhubarb Pie",
                photoUrlLarge: MockImage.foodSaladHot,
                photoUrlSmall: MockImage.foodSaladHot,
                sourceUrl: "https://www.joyofbaking.com/StrawberryRhubarbPie.html",
                youtubeUrl: "https://www.youtube.com/watch?v=tGw5Pwm4YA0"
            ),
            .init(
                uuid: "9f5a753e-472d-413e-a05b-ffbc8032e64c",
                cuisine: "Canadian",
                name: "Sugar Pie",
                photoUrlLarge: MockImage.foodSaladChicken,
                photoUrlSmall: MockImage.foodSaladChicken,
                sourceUrl: "http://allrecipes.com/recipe/213595/miraculous-canadian-sugar-pie/",
                youtubeUrl: "https://www.youtube.com/watch?v=uVQ66jiL-Dc"
            ),
            .init(
                uuid: "9dd84450-9922-463a-bece-64f32f7a7dc5",
                cuisine: "British",
                name: "Summer Pudding",
                photoUrlLarge: MockImage.foodBeef,
                photoUrlSmall: MockImage.foodBeef,
                sourceUrl: "https://www.bbcgoodfood.com/recipes/4516/summer-pudding",
                youtubeUrl: "https://www.youtube.com/watch?v=akJIO6UhXtA"
            ),
            .init(
                uuid: "744859ba-df52-4d56-b919-55fab43e8a45",
                cuisine: "French",
                name: "Tarte Tatin",
                photoUrlLarge: MockImage.foodFish,
                photoUrlSmall: MockImage.foodFish,
                sourceUrl: "https://www.bbcgoodfood.com/recipes/tarte-tatin",
                youtubeUrl: "https://www.youtube.com/watch?v=8xDM8U6h9Pw"
            ),
            .init(
                uuid: "20e87ac3-e409-418c-a503-b466ab9b3752",
                cuisine: "Canadian",
                name: "Timbits",
                photoUrlLarge: MockImage.foodSushi,
                photoUrlSmall: MockImage.foodSushi,
                sourceUrl: "http://www.geniuskitchen.com/recipe/drop-doughnuts-133877",
                youtubeUrl: "https://www.youtube.com/watch?v=fFLn1h80AGQ"
            ),
            .init(
                uuid: "55dcfb29-fe1b-4c28-8d0b-361497ae27f7",
                cuisine: "British",
                name: "Treacle Tart",
                photoUrlLarge: MockImage.foodSaladHot,
                photoUrlSmall: MockImage.foodSaladHot,
                sourceUrl: "https://www.bbc.co.uk/food/recipes/mary_berrys_treacle_tart_28524",
                youtubeUrl: "https://www.youtube.com/watch?v=YMmgKCNcqwI"
            ),
            .init(
                uuid: "a1bedde3-2bc6-46f9-ab3c-0d98a2b11b64",
                cuisine: "Tunisian",
                name: "Tunisian Orange Cake",
                photoUrlLarge: MockImage.foodSaladChicken,
                photoUrlSmall: MockImage.foodSaladChicken,
                sourceUrl: "https://www.epicurious.com/recipes/member/views/tunisian-orange-cake-50137377",
                youtubeUrl: "https://www.youtube.com/watch?v=4qEDJv10lM8"
            )
        ]
        
    }
}
#endif
