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

public class Mapper<T: Mappable>  {

    public init(){

    }

    public func fromJSON(jsonData: [String : AnyObject]) throws -> [T] {

        var objects = [T]()
        
        let jsonapiDocument = try JSONAPIDocument(JSON: jsonData)
        for resourceData in jsonapiDocument.resourceData {
            let object = T()
            let map = MapFromJSON(
                resourceData: resourceData,
                includedData: jsonapiDocument.includedData,
                mappableObject: object
            )
            
            object.map(map)
            objects.append(object)
        }
        
        return objects
    }

    public func createResourceDictionary(resourceObject: T) throws  -> [String : AnyObject] {

        let map = CreateResourceMap(object: resourceObject)
        resourceObject.map(map)

        return map.objectJSON
    }

    public func createResourceJSON(resourceObject: T) throws  -> String {
        return try toJSONString(createResourceDictionary(resourceObject))
    }

    public func updateResourceDictionary(resourceObject: T) throws  -> [String : AnyObject] {

        let map = UpdateResourceMap(object: resourceObject)
        resourceObject.map(map)

        return map.objectJSON
    }

    public func updateResourceJSON(resourceObject: T) throws  -> String {
        return try toJSONString(updateResourceDictionary(resourceObject))
    }

    public func updateRelationshipDictionary(
        resourceObject: T,
        relationship: String
    ) throws  -> [String : AnyObject] {

        let map = UpdateRelationshipMap(
            resourceObject: resourceObject,
            relationship: relationship
        )

        resourceObject.map(map)

        return map.objectJSON
    }

    public func updateRelationshipJSON(
        resourceObject: T,
        relationship: String
    ) throws  -> String {
        return try toJSONString(updateRelationshipDictionary(
            resourceObject,
            relationship: relationship
        ))
    }

    // MARK: private funcs
    private func toJSONString(dictionary: [String : AnyObject]) throws -> String {
        let data = try NSJSONSerialization.dataWithJSONObject(
            dictionary,
            options: NSJSONWritingOptions()
        )

        guard let stringData = NSString(data: data, encoding: NSUTF8StringEncoding) else {
            fatalError()
        }

        return stringData as String
    }

}
