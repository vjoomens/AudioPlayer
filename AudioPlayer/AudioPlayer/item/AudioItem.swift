//
//  AudioItem.swift
//  AudioPlayer
//
//  Created by Kevin DELANNOY on 12/03/16.
//  Copyright © 2016 Kevin Delannoy. All rights reserved.
//

import AVFoundation
#if os(iOS) || os(tvOS)
    import UIKit
    import MediaPlayer

    public typealias Image = UIImage
#else
    import Cocoa

    public typealias Image = NSImage
#endif

// MARK: - AudioQuality

/// `AudioQuality` differentiates qualities for audio.
///
/// - low: The lowest quality.
/// - medium: The quality between highest and lowest.
/// - high: The highest quality.
public enum AudioQuality: Int {
    case low = 0
    case medium = 1
    case high = 2
}

// MARK: - AudioItemAsset

/// `AudioItemAsset` contains information about an Item Asset such as its quality.
public struct AudioItemAsset {
    /// The quality of the stream.
    public let quality: AudioQuality

    /// The asset of the stream.
    public let asset: AVURLAsset

    /// Initializes an AudioItemAsset.
    ///
    /// - Parameters:
    ///   - quality: The quality of the stream.
    ///   - asset: The asset of the stream.
    public init?(quality: AudioQuality, asset: AVURLAsset?) {
        guard let asset = asset else { return nil }

        self.quality = quality
        self.asset = asset
    }
}

// MARK: - AudioItem

/// An `AudioItem` instance contains every piece of information needed for an `AudioPlayer` to play.
///
/// Assets can be remote or local.
open class AudioItem: NSObject {
    /// Returns the available qualities.
    public let assets: [AudioQuality: AVURLAsset]

    // MARK: Initialization

    /// Initializes an AudioItem. Fails if every urls are nil.
    ///
    /// - Parameters:
    ///   - highQualitySoundAsset: The asset for the high quality sound.
    ///   - mediumQualitySoundAsset: The asset for the medium quality sound.
    ///   - lowQualitySoundAsset: The asset for the low quality sound.
    public convenience init?(highQualitySoundAsset: AVURLAsset? = nil,
                             mediumQualitySoundAsset: AVURLAsset? = nil,
                             lowQualitySoundAsset: AVURLAsset? = nil) {
        var assets = [AudioQuality: AVURLAsset]()
        if let highURL = highQualitySoundAsset {
            assets[.high] = highURL
        }
        if let mediumURL = mediumQualitySoundAsset {
            assets[.medium] = mediumURL
        }
        if let lowURL = lowQualitySoundAsset {
            assets[.low] = lowURL
        }
        self.init(assets: assets)
    }

    /// Initializes an `AudioItem`.
    ///
    /// - Parameter assets: The assets of the sound associated with its quality wrapped in a `Dictionary`.
    public init?(assets: [AudioQuality: AVURLAsset]) {
        self.assets = assets
        super.init()

        if assets.isEmpty {
            return nil
        }
    }

    // MARK: Quality selection

    /// Returns the highest quality asset found or nil if no assets are available
    open var highestQualityAsset: AudioItemAsset {
        //swiftlint:disable force_unwrapping
        return (AudioItemAsset(quality: .high, asset: assets[.high]) ??
            AudioItemAsset(quality: .medium, asset: assets[.medium]) ??
            AudioItemAsset(quality: .low, asset: assets[.low]))!
    }

    /// Returns the medium quality asset found or nil if no assets are available
    open var mediumQualityAsset: AudioItemAsset {
        //swiftlint:disable force_unwrapping
        return (AudioItemAsset(quality: .medium, asset: assets[.medium]) ??
            AudioItemAsset(quality: .low, asset: assets[.low]) ??
            AudioItemAsset(quality: .high, asset: assets[.high]))!
    }

    /// Returns the lowest quality asset found or nil if no assets are available
    open var lowestQualityAsset: AudioItemAsset {
        //swiftlint:disable force_unwrapping
        return (AudioItemAsset(quality: .low, asset: assets[.low]) ??
            AudioItemAsset(quality: .medium, asset: assets[.medium]) ??
            AudioItemAsset(quality: .high, asset: assets[.high]))!
    }

    /// Returns an asset that best fits a given quality.
    ///
    /// - Parameter quality: The quality for the requested asset.
    /// - Returns: The asset that best fits the given quality.
    func asset(for quality: AudioQuality) -> AudioItemAsset {
        switch quality {
        case .high:
            return highestQualityAsset
        case .medium:
            return mediumQualityAsset
        default:
            return lowestQualityAsset
        }
    }

    // MARK: Additional properties

    /// The artist of the item.
    ///
    /// This can change over time which is why the property is dynamic. It enables KVO on the property.
    @objc open dynamic var artist: String?

    /// The title of the item.
    ///
    /// This can change over time which is why the property is dynamic. It enables KVO on the property.
    @objc open dynamic var title: String?

    /// The album of the item.
    ///
    /// This can change over time which is why the property is dynamic. It enables KVO on the property.
    @objc open dynamic var album: String?

    ///The track count of the item's album.
    ///
    /// This can change over time which is why the property is dynamic. It enables KVO on the property.
    @objc open dynamic var trackCount: NSNumber?

    /// The track number of the item in its album.
    ///
    /// This can change over time which is why the property is dynamic. It enables KVO on the property.
    @objc open dynamic var trackNumber: NSNumber?

    /// The artwork image of the item.
    open var artworkImage: Image? {
        get {
            #if os(OSX)
                return artwork
            #else
                return artwork?.image(at: imageSize ?? CGSize(width: 512, height: 512))
            #endif
        }
        set {
            #if os(OSX)
                artwork = newValue
            #else
                imageSize = newValue?.size
                artwork = newValue.map { image in
                    if #available(iOS 10.0, tvOS 10.0, *) {
                        return MPMediaItemArtwork(boundsSize: image.size) { _ in image }
                    }
                    return MPMediaItemArtwork(image: image)
                }
            #endif
        }
    }

    /// The artwork image of the item.
    ///
    /// This can change over time which is why the property is dynamic. It enables KVO on the property.
    #if os(OSX)
    @objc open dynamic var artwork: Image?
    #else
    @objc open dynamic var artwork: MPMediaItemArtwork?

    /// The image size.
    private var imageSize: CGSize?
    #endif

    // MARK: Metadata

    /// Parses the metadata coming from the stream/file specified in the URL's. The default behavior is to set values
    /// for every property that is nil. Customization is available through subclassing.
    ///
    /// - Parameter items: The metadata items.
    open func parseMetadata(_ items: [AVMetadataItem]) {
        items.forEach {
            if let commonKey = $0.commonKey {
                switch commonKey {
                case AVMetadataKey.commonKeyTitle where title == nil:
                    title = $0.value as? String
                case AVMetadataKey.commonKeyArtist where artist == nil:
                    artist = $0.value as? String
                case AVMetadataKey.commonKeyAlbumName where album == nil:
                    album = $0.value as? String
                case AVMetadataKey.id3MetadataKeyTrackNumber where trackNumber == nil:
                    trackNumber = $0.value as? NSNumber
                case AVMetadataKey.commonKeyArtwork where artwork == nil:
                    artworkImage = ($0.value as? Data).flatMap { Image(data: $0) }
                default:
                    break
                }
            }
        }
    }
}
