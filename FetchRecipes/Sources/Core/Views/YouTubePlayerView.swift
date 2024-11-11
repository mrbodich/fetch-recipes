//
//  YouTubePlayerView.swift
//  FetchRecipes
//
//  Created by Bogdan Chornobryvets on 11/11/24.
//

import SwiftUI
import YouTubeiOSPlayerHelper

struct YouTubePlayerView: UIViewRepresentable {
    var videoID: String

    func makeUIView(context: Context) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.load(withVideoId: videoID, playerVars: ["playsinline": 1, "autoplay": 1, "rel": 0])
        return playerView
    }

    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        // Update logic if needed
    }
}

#Preview {
    YouTubePlayerView(videoID: "jNQXAC9IVRw")
}
