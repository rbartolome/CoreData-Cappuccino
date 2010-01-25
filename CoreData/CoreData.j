//
//  CoreData.j
//
//  Created by Raphael Bartolome on 15.09.09.
//

@import <Foundation/Foundation.j>

@import "CPPersistantStore.j"
@import "CPPersistantStoreType.j"
@import "CPManagedObjectContext.j"

@import "CPManagedObjectID.j"
@import "CPManagedObject.j"
@import "CPManagedObjectModel.j"
@import "CPEntityDescription.j"
@import "CPAttributeDescription.j"
@import "CPPropertyDescription.j"
@import "CPFetchRequest.j"

@import "CoreDataCategories/CoreDataCategories.j"
@import "NSCoreData/NSCoreData.j"

//Memory store
@import "CoreDataPersistantStores/MemoryStore/CPDMemoryStore.j"
@import "CoreDataPersistantStores/MemoryStore/CPDMemoryStoreType.j"

//WebDAV store
@import "CoreDataPersistantStores/WebDAVStore/CPDWebDAVStoreType.j"
@import "CoreDataPersistantStores/WebDAVStore/CPDWebDAVStore.j"

//WebObjects store
@import "CoreDataPersistantStores/WOStore/CPDWOStore.j"
@import "CoreDataPersistantStores/WOStore/CPDWOStoreType.j"

