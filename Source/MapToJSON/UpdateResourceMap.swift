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

class UpdateResourceMap: BasicMap {

    private let object: Mappable

    private var dataJSON: [String : AnyObject] {
        var dataJSON: [String : AnyObject] = [
            "type": self.object.dynamicType.resource,
            "attributes": self.fieldsDictionary
        ]


        dataJSON["id"] = self.objectId

        return dataJSON
    }

    private var objectId: String {
        guard let id = self.object.id else {
            fatalError("Missing object id")
        }

        return String(id)
    }

    var objectJSON: [String : AnyObject] {
        return ["data": self.dataJSON]
    }

    init(object: Mappable) {
        self.object = object
        super.init()
    }

}
