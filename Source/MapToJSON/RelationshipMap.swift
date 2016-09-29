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

class RelationshipMap: BasicMap {
    let object: Mappable
    private(set) var relationshipObjects = [RelationshipObject]()
    
    init(object: Mappable) {
        self.object = object
    }
    
    func retrieveRelationship(_ relationshipObject: Mappable) {
        let dataObject = DataObject(mappableObject: relationshipObject)
        
        for (key, value) in type(of: self.object).relationships {
            if value == type(of: relationshipObject) {
                let relationshipObject = RelationshipObject(relationshipName: key, dataObjects: [dataObject])
                self.relationshipObjects.append(relationshipObject)
            } // end if
        } // end for
    }
    
    func retrieveRelationships<T: Mappable>(_ mappableRelationshipObjects: [T]) {
        var dataObjects = [DataObject]()
        let possibleRelationships = type(of: self.object).relationships
        var relationshipName = ""
        for mappableRelationshipObject in mappableRelationshipObjects {
            possibleRelationships.forEach() {
                if $0.1 == type(of: mappableRelationshipObject) {
                    dataObjects.append(DataObject(mappableObject: mappableRelationshipObject))
                    relationshipName = $0.0
                }
            }
        } // end for
        
        if relationshipName.isEmpty {
            print("Missing Name")
            return
        }
        
        let relationshipObject = RelationshipObject(relationshipName: relationshipName, dataObjects: dataObjects)
        self.relationshipObjects.append(relationshipObject)
    }
    
}
