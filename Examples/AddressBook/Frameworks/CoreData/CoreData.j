//
//  CoreData.j
//
//  Created by Raphael Bartolome on 15.09.09.
//

@import <Foundation/Foundation.j>

@import "CPPersistantStore.j"
@import "CPPersistantStoreType.j"
@import "CPPersistentStoreCoordinator.j"
@import "CPManagedObjectContext.j"

@import "CPManagedObjectID.j"
@import "CPManagedObject.j"
@import "CPManagedObjectModel.j"
@import "CPEntityDescription.j"
@import "CPAttributeDescription.j"
@import "CPPropertyDescription.j"
@import "CPFetchedPropertyDescription.j"
@import "CPFetchRequest.j"
@import "CPFetchRequestTemplates.j"

@import "CPCoreDataCategories/CPCoreDataCategories.j"
@import "NSCoreData/NSCoreData.j"

//Memory store
@import "CPCoreDataPersistantStores/MemoryStore/CPMemoryStore.j"
@import "CPCoreDataPersistantStores/MemoryStore/CPMemoryStoreType.j"

//WebDAV store
@import "CPCoreDataPersistantStores/WebDAVStore/CPWebDAVStoreType.j"
@import "CPCoreDataPersistantStores/WebDAVStore/CPWebDAVStore.j"

//HTML5 store
@import "CPCoreDataPersistantStores/HTML5Store/CPHTML5Store.j"
@import "CPCoreDataPersistantStores/HTML5Store/CPHTML5StoreType.j"

//WebObjects store
@import "CPCoreDataPersistantStores/WOStore/CPWOStore.j"
@import "CPCoreDataPersistantStores/WOStore/CPWOStoreType.j"


//CPPredicate from cocaodev @ github
@import "CPPredicate/CPPredicate.j"
@import "CPPredicate/CPScanner.j"
@import "CPPredicate/CPCharacterSet.j"