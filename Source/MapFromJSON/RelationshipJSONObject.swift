// Copyright (c) 2015-2016 Giorgos Tsiapaliokas <giorgos.tsiapaliokas@mykolab.com>
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

struct RelationshipJSONObject {
    let resourceType: String
    let jsonField: String
    let id: Int

    private init(resourceType: String, jsonField: String, id: Int) {
        self.resourceType = resourceType
        self.id = id
        self.jsonField = jsonField
    }

    static func fromJSON(JSON: [String : AnyObject]) -> [RelationshipJSONObject]? {

        var objects = [RelationshipJSONObject]()

        for it in JSON.keys {

            guard let jsonObject = JSON[it] as? [String : AnyObject] else {
                return nil
            }

            if
                let jsonData = jsonObject["data"] as? [String : AnyObject],
                let type = jsonData["type"] as? String,
                let jsonId = jsonData["id"] as? String,
                let id = Int(jsonId)
            {
                let object = RelationshipJSONObject(
                    resourceType: type,
                    jsonField: it,
                    id: id
                )
                objects.append(object)
            } else if let jsonData = jsonObject["data"] as? [[String : AnyObject]] {

                for dataItem in jsonData {
                    let object = RelationshipJSONObject(
                        resourceType: dataItem["type"] as! String,
                        jsonField: it,
                        id: Int(dataItem["id"] as! String)!
                    )

                    objects.append(object)
                } // end for
            } // end if
        } // end for keys

        return objects
    }
}
