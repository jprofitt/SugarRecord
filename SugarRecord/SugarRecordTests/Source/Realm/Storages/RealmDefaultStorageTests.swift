import Foundation
import Quick
import Nimble
import RealmSwift

@testable import SugarRecord

class RealmDefaultStorageTests: QuickSpec {
    
    override func spec() {
        
        var storage: RealmDefaultStorage?
        
        beforeEach {
            storage = RealmDefaultStorage()
        }
        
        afterEach {
            _ = try? storage?.removeStore()
        }
        
        
        describe("storage information") {
            
            it("should have the proper description") {
                expect(storage?.description) == "RealmDefaultStorage"
            }
            
            it("should have the proper type") {
                expect(storage?.type) == .Realm
            }
            
        }
        
        describe("context generation") {
            
            it("should return a memory realm for the memory context") {
                let memoryRealm: Realm? = storage?.memoryContext as? Realm
                expect(memoryRealm?.configuration.inMemoryIdentifier) == "MemoryRealm"
            }
            
        }
        
        describe("store operations") {
            
            context("removal") {
                
                it("should remove the storage") {
                    _ = try? storage?.removeStore()
                    let path = try? Realm().path
                    expect(NSFileManager.defaultManager().fileExistsAtPath(path!)) == false
                }
                
                it("shouldn't throw an exception") {
                    expect{ try storage!.removeStore() }.toNot(throwError())
                }
                
            }
            
        }
        
        describe("operations") {
            
            it("should save the changes if write is passed as true") {
                storage?.operation(dispatch_get_main_queue(), write: true, operation: { (context) -> Void in
                    let issue: Issue = context.insert().value!
                    issue.name = "test"
                })
                let fetched = storage?.mainContext.fetch(Request<Issue>()).value
                expect(fetched?.count) == 1
            }
            
        }
        
    }
    
}