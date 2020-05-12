//
//  AudioItem_Tests.swift
//  AudioPlayer
//
//  Created by Kevin DELANNOY on 13/03/16.
//  Copyright © 2016 Kevin Delannoy. All rights reserved.
//

import XCTest
import AVFoundation
@testable import AudioPlayer

class AudioItem_Tests: XCTestCase {
    func testItemInitializationFailsIfNoValidURLIsGiven() {
        XCTAssertNil(AudioItem(assets: [:]))
        XCTAssertNil(AudioItem(highQualitySoundAsset: nil, mediumQualitySoundAsset: nil, lowQualitySoundAsset: nil))
    }

    func testItemXXXestURL() {
        let assetLow = AVURLAsset(url: URL(string: "https://github.com")!)
        let assetMedium = AVURLAsset(url: URL(string: "https://github.com/delannoyk")!)
        let assetHigh = AVURLAsset(url: URL(string: "https://github.com/delannoyk/AudioPlayer")!)

        let itemLowOnly = AudioItem(lowQualitySoundAsset: assetLow)
        XCTAssertEqual(itemLowOnly?.lowestQualityAsset.asset, assetLow)
        XCTAssertEqual(itemLowOnly?.mediumQualityAsset.asset, assetLow)
        XCTAssertEqual(itemLowOnly?.highestQualityAsset.asset, assetLow)

        let itemMediumOnly = AudioItem(mediumQualitySoundAsset: assetMedium)
        XCTAssertEqual(itemMediumOnly?.lowestQualityAsset.asset, assetMedium)
        XCTAssertEqual(itemMediumOnly?.mediumQualityAsset.asset, assetMedium)
        XCTAssertEqual(itemMediumOnly?.highestQualityAsset.asset, assetMedium)

        let itemHighOnly = AudioItem(highQualitySoundAsset: assetHigh)
        XCTAssertEqual(itemHighOnly?.lowestQualityAsset.asset, assetHigh)
        XCTAssertEqual(itemHighOnly?.mediumQualityAsset.asset, assetHigh)
        XCTAssertEqual(itemHighOnly?.highestQualityAsset.asset, assetHigh)

        let itemLowMediumOnly = AudioItem(mediumQualitySoundAsset: assetMedium, lowQualitySoundAsset: assetLow)
        XCTAssertEqual(itemLowMediumOnly?.lowestQualityAsset.asset, assetLow)
        XCTAssertEqual(itemLowMediumOnly?.mediumQualityAsset.asset, assetMedium)
        XCTAssertEqual(itemLowMediumOnly?.highestQualityAsset.asset, assetMedium)

        let itemLowHighOnly = AudioItem(highQualitySoundAsset: assetHigh, lowQualitySoundAsset: assetLow)
        XCTAssertEqual(itemLowHighOnly?.lowestQualityAsset.asset, assetLow)
        XCTAssertEqual(itemLowHighOnly?.mediumQualityAsset.asset, assetLow)
        XCTAssertEqual(itemLowHighOnly?.highestQualityAsset.asset, assetHigh)

        let itemMediumHighOnly = AudioItem(highQualitySoundAsset: assetHigh, mediumQualitySoundAsset: assetMedium)
        XCTAssertEqual(itemMediumHighOnly?.lowestQualityAsset.asset, assetMedium)
        XCTAssertEqual(itemMediumHighOnly?.mediumQualityAsset.asset, assetMedium)
        XCTAssertEqual(itemMediumHighOnly?.highestQualityAsset.asset, assetHigh)

        let itemFull = AudioItem(highQualitySoundAsset: assetHigh, mediumQualitySoundAsset: assetMedium, lowQualitySoundAsset: assetLow)
        XCTAssertEqual(itemFull?.lowestQualityAsset.asset, assetLow)
        XCTAssertEqual(itemFull?.mediumQualityAsset.asset, assetMedium)
        XCTAssertEqual(itemFull?.highestQualityAsset.asset, assetHigh)
    }

    func testItemURLForQuality() {
        let assetLow = AVURLAsset(url: URL(string: "https://github.com")!)
        let assetMedium = AVURLAsset(url: URL(string: "https://github.com/delannoyk")!)
        let assetHigh = AVURLAsset(url: URL(string: "https://github.com/delannoyk/AudioPlayer")!)

        let itemLowOnly = AudioItem(lowQualitySoundAsset: assetLow)
        XCTAssertEqual(itemLowOnly?.asset(for: .high).quality, .low)
        XCTAssertEqual(itemLowOnly?.asset(for: .medium).quality, .low)
        XCTAssertEqual(itemLowOnly?.asset(for: .low).quality, .low)

        let itemMediumOnly = AudioItem(mediumQualitySoundAsset: assetMedium)
        XCTAssertEqual(itemMediumOnly?.asset(for: .high).quality, .medium)
        XCTAssertEqual(itemMediumOnly?.asset(for: .medium).quality, .medium)
        XCTAssertEqual(itemMediumOnly?.asset(for: .low).quality, .medium)

        let itemHighOnly = AudioItem(highQualitySoundAsset: assetHigh)
        XCTAssertEqual(itemHighOnly?.asset(for: .high).quality, .high)
        XCTAssertEqual(itemHighOnly?.asset(for: .medium).quality, .high)
        XCTAssertEqual(itemHighOnly?.asset(for: .low).quality, .high)

        let itemLowMediumOnly = AudioItem(mediumQualitySoundAsset: assetMedium, lowQualitySoundAsset: assetLow)
        XCTAssertEqual(itemLowMediumOnly?.asset(for: .high).quality, .medium)
        XCTAssertEqual(itemLowMediumOnly?.asset(for: .medium).quality, .medium)
        XCTAssertEqual(itemLowMediumOnly?.asset(for: .low).quality, .low)

        let itemLowHighOnly = AudioItem(highQualitySoundAsset: assetHigh, lowQualitySoundAsset: assetLow)
        XCTAssertEqual(itemLowHighOnly?.asset(for: .high).quality, .high)
        XCTAssertEqual(itemLowHighOnly?.asset(for: .medium).quality, .low)
        XCTAssertEqual(itemLowHighOnly?.asset(for: .low).quality, .low)

        let itemMediumHighOnly = AudioItem(highQualitySoundAsset: assetHigh, mediumQualitySoundAsset: assetMedium)
        XCTAssertEqual(itemMediumHighOnly?.asset(for: .high).quality, .high)
        XCTAssertEqual(itemMediumHighOnly?.asset(for: .medium).quality, .medium)
        XCTAssertEqual(itemMediumHighOnly?.asset(for: .low).quality, .medium)

        let itemFull = AudioItem(highQualitySoundAsset: assetHigh, mediumQualitySoundAsset: assetMedium, lowQualitySoundAsset: assetLow)
        XCTAssertEqual(itemFull?.asset(for: .high).quality, .high)
        XCTAssertEqual(itemFull?.asset(for: .medium).quality, .medium)
        XCTAssertEqual(itemFull?.asset(for: .low).quality, .low)
    }

    func testParseMetadata() {
        let imageURL = Bundle(for: type(of: self)).url(forResource: "image", withExtension: "png")!
        let imageData = NSData(contentsOf: imageURL)!

        let metadata = [
            FakeMetadataItem(commonKey: AVMetadataKey.commonKeyTitle, value: "title" as NSString),
            FakeMetadataItem(commonKey: AVMetadataKey.commonKeyArtist, value: "artist" as NSString),
            FakeMetadataItem(commonKey: AVMetadataKey.commonKeyAlbumName, value: "album" as NSString),
            FakeMetadataItem(commonKey: AVMetadataKey.id3MetadataKeyTrackNumber, value: NSNumber(value: 1)),
            FakeMetadataItem(commonKey: AVMetadataKey.commonKeyArtwork, value: imageData)
        ]

        let item = AudioItem(assets: [.low: AVURLAsset(url: URL(string: "https://github.com")!)])
        item?.parseMetadata(metadata)

        XCTAssertEqual(item?.title, "title")
        XCTAssertEqual(item?.artist, "artist")
        XCTAssertEqual(item?.album, "album")
        XCTAssertEqual(item?.trackNumber?.intValue, 1)
        XCTAssertNotNil(item?.artworkImage)
    }

    func testParseMetadataDoesNotOverrideUserProperties() {
        let item = AudioItem(assets: [.low: AVURLAsset(url: URL(string: "https://github.com")!)])
        item?.title = "title"
        item?.artist = "artist"
        item?.album = "album"
        item?.trackNumber = NSNumber(value: 1)

        let metadata = [
            FakeMetadataItem(commonKey: AVMetadataKey.commonKeyTitle, value: "abc" as NSString),
            FakeMetadataItem(commonKey: AVMetadataKey.commonKeyArtist, value: "def" as NSString),
            FakeMetadataItem(commonKey: AVMetadataKey.commonKeyAlbumName, value: "ghi" as NSString),
            FakeMetadataItem(commonKey: AVMetadataKey.id3MetadataKeyTrackNumber, value: NSNumber(value: 10))
        ]
        item?.parseMetadata(metadata)

        XCTAssertEqual(item?.title, "title")
        XCTAssertEqual(item?.artist, "artist")
        XCTAssertEqual(item?.album, "album")
        XCTAssertEqual(item?.trackNumber?.intValue, 1)
    }
}
