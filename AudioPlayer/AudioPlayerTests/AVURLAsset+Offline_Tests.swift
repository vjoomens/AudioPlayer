
//
//  URL+Offline_Tests.swift
//  AudioPlayer
//
//  Created by Kevin DELANNOY on 15/05/16.
//  Copyright © 2016 Kevin Delannoy. All rights reserved.
//
import XCTest
import AVFoundation
@testable import AudioPlayer

class URL_Offline_Tests: XCTestCase {
    func testOfflineURLs() {
        XCTAssertTrue(AVURLAsset(url: URL(fileURLWithPath: "/home/xxx")).ap_isOfflineURL)
        XCTAssertTrue(AVURLAsset(url: URL(string: "http://localhost://")!).ap_isOfflineURL)
        XCTAssertTrue(AVURLAsset(url: URL(string: "http://127.0.0.1/xxx")!).ap_isOfflineURL)
    }

    func testOnlineURL() {
        XCTAssertFalse(AVURLAsset(url: URL(string: "http://google.com")!).ap_isOfflineURL)
        XCTAssertFalse(AVURLAsset(url: URL(string: "http://apple.com")!).ap_isOfflineURL)
    }
}
