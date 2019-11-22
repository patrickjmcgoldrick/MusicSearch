//
//  AlbumData.swift
//  Beatles Table View
//
//  Created by dirtbag on 11/21/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

struct AlbumData : Codable {
    var resultCount : Int?
    var results : [Result]
}

struct Result : Codable, Equatable {
    var artistName : String
    var collectionName : String
    var trackName : String?
    var artworkUrl100 : String?
    var collectionId : Int
    var trackNumber : Int?
    var trackTimeMillis : Int?
    
    // conform to Equatable protocol
    // use this to thin to a list of unique 'collectionName' rows
    static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.collectionName == rhs.collectionName
    }
}
