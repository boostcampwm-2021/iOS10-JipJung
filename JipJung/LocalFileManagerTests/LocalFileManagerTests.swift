//
//  LocalFileMangerTests.swift
//  LocalFileMangerTests
//
//  Created by Soohyeon Lee on 2021/11/04.
//

import XCTest

class LocalFileMangerTests: XCTestCase {
    
    var localFileManager: LocalFileManager!
    
    let testDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    
    let testFileName = "Test.txt"
    let testFileContents = "test"
    
    override func setUpWithError() throws {
        localFileManager = LocalFileManager.shared
        
        let filePath = testDirectory.appendingPathComponent(testFileName)
        FileManager.default.createFile(atPath: filePath.path, contents: testFileContents.data(using: .utf8))
    }
    
    override func tearDownWithError() throws {
        localFileManager = nil
        
        let filePath = testDirectory.appendingPathComponent(testFileName)
        try? FileManager.default.removeItem(at: filePath)
    }
    
    func test_LocalFileManager_Read_Success() {
        // Given
        let fileName = testFileName
        // When
        let fileData = localFileManager.read(fileName)
        // Then
        XCTAssertNotNil(fileData)
        
        guard let fileData = fileData else {
            XCTFail("Error: FileData is Nil")
            return
        }
        
        // Given
        let contents = testFileContents
        // When
        let fileString = String(data: fileData, encoding: .utf8)
        // Then
        XCTAssertEqual(fileString, contents)
    }
    
    func test_LocalFileManager_Read_Fail() {
        // Given
        let newFileName = "a"
        // When
        let fileData = localFileManager.read(newFileName)
        // Then
        XCTAssertNil(fileData)
    }
    
    func test_LocalFileManager_Write_Success() {
        // Given
        let fileName = testFileName
        // When
        let fileData = localFileManager.read(fileName)
        // Then
        XCTAssertNotNil(fileData)
        
        guard let fileData = fileData else {
            XCTFail("Error: FileData is Nil")
            return
        }
        
        // Given
        let contents = testFileContents
        // When
        let fileString = String(data: fileData, encoding: .utf8)
        // Then
        XCTAssertEqual(fileString, contents)
    }
    
    func test_LocalFileManager_Delete_Success() {
        // Given
        let fileName = testFileName
        // When
        let fileData = localFileManager.delete(fileName)
        // Then
        XCTAssertTrue(fileData)
        
        // When
        let filePath = testDirectory.appendingPathComponent(fileName)
        let isExist = FileManager.default.fileExists(atPath: filePath.path)
        // Then
        XCTAssertFalse(isExist)
    }
    
    func test_LocalFileManager_Delete_Fail() {
        // Given
        let newFileName = "a"
        // When
        let fileData = localFileManager.delete(newFileName)
        // Then
        XCTAssertFalse(fileData)
    }
}
