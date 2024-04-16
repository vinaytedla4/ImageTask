//
//  Model.swift
//  sampletask
//
//  Created by Vinay on 10/01/24.
//

import Foundation

//struct ToDo: Codable {
////    let message: String
////    let status: Int
////    let data: [Category]
//    let albumId: Int
//    let id: Int
//    let title: String
//    let url: URL
//    let thumbnailUrl: String
//}

//struct Category: Codable {
//    let id: Int
//    let name: String
//    let typeOfCategory: String
//    let parentId: Int
//    let parentName: String
//    let imgUrl: String?
//    let appIcon: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case name = "name"
//        case typeOfCategory = "type_of_category"
//        case parentId = "parent_id"
//        case parentName = "parent_name"
//        case imgUrl = "img_url"
//        case appIcon = "app_icon"
//    }
//}


import Foundation

// MARK: - WelcomeElement
struct ToDo: Codable {
    let id, title: String
    let language: Language
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt, publishedBy: String
    let backupDetails: BackupDetails?
}

// MARK: - BackupDetails
struct BackupDetails: Codable {
    let pdfLink: String
    let screenshotURL: String
}

enum Language: String, Codable {
    case english = "english"
    case hindi = "hindi"
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: Key
    let qualities: [Int]
    let aspectRatio: Double
}

enum Key: String, Codable {
    case imageJpg = "image.jpg"
}
