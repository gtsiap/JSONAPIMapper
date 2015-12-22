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

class MapFromJSON: BasicMap {

    private let includedData: [[String : AnyObject]]
    private let resourceData: [String : AnyObject]

    private lazy var fieldsData: [String : AnyObject] = {
        var fieldsData = [String : AnyObject]()

        if let fieldsData = self.resourceData["attributes"] as? [String : AnyObject] {
            return fieldsData
        }

        return [String : AnyObject]()
    }()

    private lazy var relationships: [RelationshipJSONObject]? = {
        if let relationships = self.resourceData["relationships"] as? [String : AnyObject] {
            return RelationshipJSONObject.fromJSON(relationships)
        }

        return nil
    }()

    init(
        resourceData: [String : AnyObject],
        includedData: [[String : AnyObject ]],
        mappableObject: Mappable
    ) {
        self.resourceData = resourceData
        self.includedData = includedData

        guard let jsonId = self.resourceData["id"] as? String, id = Int(jsonId) else { fatalError("WTF") }
        mappableObject.id = id
    }

    convenience init(resourceData: [String : AnyObject], mappableObject: Mappable) {
        self.init(
            resourceData: resourceData,
            includedData: [[String : AnyObject ]](),
            mappableObject: mappableObject
        )
    }

    func resourceValue<T>() -> T? {
        return self.fieldsData[self.currentKey] as? T
    }

    func relationshipValue<T: Mappable>() -> T? {

        guard let relationships = self.relationships else {
            return nil
        }

        let filteredRelationships = relationships.filter() {
            $0.jsonField == self.currentKey
        }

        if filteredRelationships.count == 0 {
            print("Wrong Relationship for key: \(self.currentKey)")
            print("The available fields are:")
            for it in relationships {
                print(it.jsonField)
            }

            print("The resource data are:")
            print(self.resourceData)

            return nil
        }


        return relationshipValueCommon(filteredRelationships[0])
    }

    func relationshipValue<T: Mappable> () -> [T]? {
        guard let relationships = self.relationships else {
            return nil
        }

        let relationshipList = relationships.filter() {
            $0.jsonField == self.currentKey
        }

        var relationshipObjects = [T]()
        for relationship in relationshipList {
            let objectOptional: T? = relationshipValueCommon(relationship)

            guard let object = objectOptional else { continue }

            relationshipObjects.append(object)
        }

        guard relationshipObjects.count != 0 else { return nil }
        return relationshipObjects
    }

    private func relationshipValueCommon<T: Mappable>(relationship: RelationshipJSONObject) -> T? {

        let relationshipObject = T()

        for includeDataIt in self.includedData {
            guard let
                dataId = includeDataIt["id"] as? String,
                id = Int(dataId),
                resourceType = includeDataIt["type"] as? String
                where id == relationship.id && resourceType == relationship.resourceType
            else { continue }

            let map = MapFromJSON(
                resourceData: includeDataIt,
                mappableObject: relationshipObject
            )

            relationshipObject.map(map)
            return relationshipObject

        }

        // retrieve the object in the included section of the json
        // it won't be a complete json. We can't retrieve the entire object,
        // because the attributes are missing but at least we will retrieve the id

        guard let
            includedDataRelationship = self.resourceData["relationships"]
                as? [String : AnyObject],
            includedObjectJSON = includedDataRelationship[self.currentKey] as? [String : AnyObject],
            includedObjectData = includedObjectJSON["data"] as? [String : AnyObject],
            includedStringId = includedObjectData["id"] as? String,
            includedResourceType = includedObjectData["type"] as? String,
            includedId = Int(includedStringId)
            where includedResourceType == relationshipObject.dynamicType.resource
        else { return nil }

        relationshipObject.id = includedId
        return relationshipObject
    }

}
