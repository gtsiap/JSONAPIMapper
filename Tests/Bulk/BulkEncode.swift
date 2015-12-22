//
//  BulkEncode.swift
//  JSONAPIMapper
//
//  Created by Giorgos Tsiapaliokas on 22/12/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import XCTest
import JSONAPIMapper

import JSONAPIMapper

final class Photo {
    
    var id: Int?
    var title: String?
    var src: String?
    
}

extension Photo: Mappable {
    
    static var resource: String {
        return "photos"
    }
    
    static var relationships: [String : Mappable.Type] {
        return [String : Mappable.Type]()
    }
    
    func map(map: Map) {
        self.title <~ map["title"]
        self.src   <~ map["src"]
    }
}


class BulkEncode: BaseTestCase {

    func testCreateResources() {
        var photos = [Photo]()
        var photo = Photo()
        
        photo.title = "Photo 1"
        photo.src = "http://example.com/photo1.png"
        
        photos.append(photo)
        
        photo = Photo()
        photo.title = "Photo 2"
        photo.src = "http://example.com/photo2.png"
        
        photos.append(photo)

        let createResourceJSONObject = try! BulkMapper<Photo>().createResourcesDictionary(photos)
        XCTAssertEqual(retrieveJSONObject("bulk_create_resources"), createResourceJSONObject as NSDictionary)
    }
}
