
// Copyright (c) 2015 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//
//  Post.swift
//  GtsiapKit
//
//  Created by Giorgos Tsiapaliokas on 8/29/15.
//  Copyright © 2015 Giorgos Tsiapaliokas. All rights reserved.
//

import JSONAPIMapper

final class Info: ObjectMappable {
    var something1: String?
    var something2: Int?
}

final class Post {

    var id: Int?
    var title: String?
    var author: Person?
    var comments: [Comment]?
    var info: Info?
}

extension Post: Mappable {

    static var resource: String {
        return "posts"
    }

    static var relationships: [String : Mappable.Type] {
        return [
            "comments": Comment.self,
            "author": Person.self
        ]
    }

    func map(map: Map) {
        self.title    <~ map["title"]
        self.author   <~ map["author"]
        self.comments <~ map["comments"]

        self.info <~ (map["info"], ObjectTransformer<Info>() { objectMap, object in
            object.something1 <~ objectMap["something1"]
            object.something2 <~ objectMap["something2"]
        })

    }
}
