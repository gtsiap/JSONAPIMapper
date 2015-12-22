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

import XCTest

@testable import JSONAPIMapper

class Encode: BaseTestCase {

    func test1ObjectWithRelationships() {
        let post = Post()
        post.title = "Some title"

        let author = Person()
        author.id = 9

        let comment1 = Comment()
        comment1.id = 1

        let comment2 = Comment()
        comment2.id = 2

        post.author = author
        post.comments = [comment1, comment2]

        let createResourceJSONObject = try! Mapper<Post>().createResourceDictionary(post)
        XCTAssertEqual(retrieveJSONObject("create_resource"), createResourceJSONObject as NSDictionary)

        post.title = "To TDD or Not"
        post.id = 1


        let updateResourceJSONObject = try! Mapper<Post>().updateResourceDictionary(post)
        XCTAssertEqual(retrieveJSONObject("update_resource"), updateResourceJSONObject)

        var updateRelationshipJSONObject = try! Mapper<Post>().updateRelationshipDictionary(
            post,
            relationship: "author"
        )

        XCTAssertEqual(retrieveJSONObject("update_relationship"), updateRelationshipJSONObject as NSDictionary)

        updateRelationshipJSONObject = try! Mapper<Post>().updateRelationshipDictionary(
            post,
            relationship: "comments"
        )

        XCTAssertEqual(retrieveJSONObject("update_relationship2"), updateRelationshipJSONObject as NSDictionary)
    }

}
