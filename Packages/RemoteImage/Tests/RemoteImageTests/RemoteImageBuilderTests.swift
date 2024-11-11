//
//  MockImageFetcher.swift
//  Networking
//
//  Created by Bogdan Chornobryvets on 11/8/24.
//

import Foundation
import UIKit
import Testing
@testable import RemoteImage

struct RemoteImageBuilderTests {
    private var imageBuilderFabric: ImageBuilderFabric!
    private var imageData: Data!
    
    init() throws {
        imageBuilderFabric = ResizingImageBuilderFabric()
        let imageURL = Bundle.module.url(forResource: "landscape", withExtension: "jpg")
        imageData = try Data(contentsOf: imageURL!)
    }
    
    @Test func mockImageSize() throws {
        //given
        /// `imageData` image size in pixels: 600x400
        
        //when
        let image = try #require(UIImage(data: imageData, scale: 2))
        
        //then
        #expect(image.size == CGSize(width: 300, height: 200))
        #expect(image.scale == 2)
    }
    
    @Test func imageBuilderOriginal() async throws {
        //given
        let builder = OriginalImageBuilder(scale: 3.0)
        
        //when
        let finalImage = builder.buildImage(from: imageData)
        
        //then
        #expect(finalImage != nil)
    }
    
    @Test func imageBuilderFitHeight() async throws {
        //given
        let builder = ResizingImageBuilder(
            size: CGSize(width: 10_000, height: 100),
            method: .fit,
            scale: 3
        )
        
        //when
        let (image, _) = try #require(builder.buildImage(from: imageData))
        
        //then
        #expect(image.size == CGSize(width: 150, height: 100))
        #expect(image.scale == 3)
    }
    
    @Test func imageBuilderFitWidth() async throws {
        //given
        let builder = ResizingImageBuilder(
            size: CGSize(width: 90, height: 10_000),
            method: .fit,
            scale: 2
        )
        
        //when
        let (image, _) = try #require(builder.buildImage(from: imageData))
        
        //then
        #expect(image.size == CGSize(width: 90, height: 60))
        #expect(image.scale == 2)
    }
    
    @Test func imageBuilderFillHeight() async throws {
        //given
        let builder = ResizingImageBuilder(
            size: CGSize(width: 1, height: 300),
            method: .fill,
            scale: 1
        )
        
        //when
        let (image, _) = try #require(builder.buildImage(from: imageData))
        
        //then
        #expect(image.size == CGSize(width: 450, height: 300))
        #expect(image.scale == 1)
    }
    
    func testImageBuilderFillWidth() async throws {
        //given
        let builder = ResizingImageBuilder(
            size: CGSize(width: 60, height: 1),
            method: .fill,
            scale: 1
        )
        
        //when
        let (image, _) = try #require(builder.buildImage(from: imageData))
        
        //then
        #expect(image.size == CGSize(width: 60, height: 40))
        #expect(image.scale == 1)
    }
    
    @Test func imageBuilderFillCropHeight() async throws {
        //given
        let builder = ResizingImageBuilder(
            size: CGSize(width: 60, height: 10),
            method: .fillcrop,
            scale: 1
        )
        
        //when
        let (image, _) = try #require(builder.buildImage(from: imageData))
        
        //then
        #expect(image.size == CGSize(width: 60, height: 10))
        #expect(image.scale == 1)
    }
    
    @Test func imageBuilderFillCropWidth() async throws {
        //given
        let builder = ResizingImageBuilder(
            size: CGSize(width: 20, height: 100),
            method: .fillcrop,
            scale: 1
        )
        
        //when
        let (image, _) = try #require(builder.buildImage(from: imageData))
        
        //then
        #expect(image.size == CGSize(width: 20, height: 100))
        #expect(image.scale == 1)
    }
    
    @Test func imageBuilderNoUpscale() async throws {
        //given
        let builder = ResizingImageBuilder(
            size: CGSize(width: 1200, height: 200),
            method: .fillcrop,
            scale: 1
        )
        
        //when
        let (image, _) = try #require(builder.buildImage(from: imageData))
        
        //then
        #expect(image.size == CGSize(width: 600, height: 100))
        #expect(image.scale == 1)
    }
}
