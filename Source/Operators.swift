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

infix operator <~ {}

public func <~ <T>(inout left: T?, right: Map) {
    if let mapFromJSON = right as? MapFromJSON {
        left = mapFromJSON.resourceValue()
    } else if let objectMap = right as? ObjectMap {
        left = objectMap.value()
    } else if let mapToJSON = right as? BasicMap {
        mapToJSON.retrieveValue(left as? AnyObject)
    }
}
public func <~ <T: ObjectMappable>(inout left: T?, right: (Map, Transformer)) {

    if let _ = right.0 as? MapFromJSON,
        objectTransformer = right.1 as? ObjectTransformer<T>
    {
        objectTransformer.object = left
        objectTransformer.fromJSON(right.0)
        left = objectTransformer.object
    }

}

public func <~ <T: Mappable>(inout left: T?, right: Map) {
    if let mapFromJSON = right as? MapFromJSON {
        left = mapFromJSON.relationshipValue()
    } else if let
        mapToJSON = right as? RelationshipMap,
        left = left
    {
        mapToJSON.retrieveRelationship(left)
    }
}

public func <~ <T: Mappable>(inout left: [T]?, right: Map) {
    if let mapFromJSON = right as? MapFromJSON {
        left = mapFromJSON.relationshipValue()
    } else if let
        mapToJSON = right as? RelationshipMap,
        left = left
    {
        mapToJSON.retrieveRelationships(left)
    }
}
