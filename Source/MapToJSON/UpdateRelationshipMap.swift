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

class UpdateRelationshipMap: RelationshipMap {

    private let relationship: String
    private let relationshipType: Mappable.Type

    var objectJSON: [String : AnyObject] {

        var data = [[String : AnyObject]]()
        for (key ,value) in self.relationshipsDictionary {

            if key != relationship {
                continue
            }

            guard let
                valueDict = value as? [String : AnyObject]
            else { fatalError() }


            var dataList = [[String : AnyObject]]()

            if let list = valueDict["data"] as? [[String : AnyObject]] {
                dataList = list
            } else if let element = valueDict["data"] as? [String : AnyObject] {
                dataList.append(element)
            } else {
                fatalError()
            }

            for it in dataList {
                guard let dataType = it["type"] as? String else { fatalError() }

                if dataType == relationshipType.resource {
                    data.append(it)
                }
            }

        }

        if data.count == 1 {
            return ["data": data[0]]
        }

        return ["data": data]
    }

    init(
        resourceObject: Mappable,
        relationship: String,
        relationshipType: Mappable.Type
    ) {
        self.relationship = relationship
        self.relationshipType = relationshipType

        super.init(object: resourceObject)
    }

}
