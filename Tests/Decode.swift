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

class Decode: XCTestCase {

    private static var JSON: [String : AnyObject] =  [String : AnyObject]()
    private static var post: Post!

    override class func setUp() {
        let jsonDataPath = NSBundle(forClass: Decode.self).URLForResource("parse_resource", withExtension: ".json")
        let jsonData = NSData(contentsOfURL: jsonDataPath!)
        let jsonObject = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments)

        Decode.JSON = jsonObject as! [String : AnyObject]
    }

    func test1Post() {
        let posts = try! Mapper<Post>().fromJSON(Decode.JSON)
        let post = posts[0]

        XCTAssertEqual(posts.count, 1)
        XCTAssertEqual(post.title, "JSON API paints my bikeshed!")
        XCTAssertNotNil(post.author)
        XCTAssertEqual(post.id, 1)

        XCTAssertNotNil(post.info)

        XCTAssertEqual(post.info!.something1, "something1")
        XCTAssertEqual(post.info!.something2, 10)

        Decode.post = post
    }

    func test2Author() {
        let author = Decode.post.author

        XCTAssertNotNil(author?.firstName)
        XCTAssertEqual(author?.firstName, "Dan")

        XCTAssertNotNil(author?.lastName)
        XCTAssertEqual(author?.lastName, "Gebhardt")

        XCTAssertNotNil(author?.twitter)
        XCTAssertEqual(author?.twitter, "dgeb")

        XCTAssertEqual(author?.id, 9)

        XCTAssertNotNil(author?.hobby)
        XCTAssertNotNil(author?.hobby?.id)
        XCTAssertEqual(author?.hobby?.id, 1)
    }

    func test3Comments() {
        let comments = Decode.post.comments
        XCTAssertEqual(comments?.count, 2)

        XCTAssertNotNil(comments?[0].body)
        XCTAssertEqual(comments?[0].body, "First!")
        XCTAssertEqual(comments?[0].id, 5)

        XCTAssertNotNil(comments?[1].body)
        XCTAssertEqual(comments?[1].body, "I like XML better")
        XCTAssertEqual(comments?[1].id, 12)
    }
}
