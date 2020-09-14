//
//  FindYourFaceTests.swift
//  FindYourFaceTests
//
//  Created by Roman on 8/18/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import XCTest
@testable import FindYourFace

class FindYourFaceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testUserRegistration() {
        let testClass = ImageNetworking()
        testClass.checkIsRegistred { (bool) in
            XCTAssert(bool)
        }
    }
    
    func testDownloadingImage() {
        let testClass = ImageNetworking()
        testClass.downloadImage(from: URL(string: "https://firebasestorage.googleapis.com/v0/b/findyourface-34b89.appspot.com/o/images%2F1599501106.4615731.png?alt=media&token=63b7762c-7159-4e6c-8ae3-77e2181cd249")!) { (image, error) in
            XCTAssert((error == nil))
        }
    }
    
    func testFetchingDataFromFirebase() {
        let testClass = ImageNetworking()
        testClass.fetchDataFromFirebase { (data) in
            XCTAssert(!(data.count == 0))
        }
    }
    
    func testFetchingLogoFromFirebase() {
        let testClass = ImageNetworking()
        testClass.fetchLogoFromFirebase { (image, error) in
            XCTAssert((error == nil))
        }
    }
    
    func testUploadingPhoto() {
        let testClass = ImageNetworking()
        let image = UIImage(named: "cat")!
        testClass.uploadPhoto(image: image, profile: true) { (error) in
            XCTAssert((error == nil))
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
