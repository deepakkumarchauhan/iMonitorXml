//
//  IMDBHelper.h
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/21/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AOPThreadSafeManagedObjectContext.h"
#import "TBL_DeviceMO+CoreDataClass.h"
#import "TBL_GatewayMO+CoreDataClass.h"
#import "TBL_DeviceMO+CoreDataProperties.h"
#import "TBL_GatewayMO+CoreDataProperties.h"



@interface IMDBHelper : NSObject {
    
    NSManagedObjectModel *managedObjectModel;
    AOPThreadSafeManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

+(id)instance;
-(void)deleteItemFromContext:(id)sender;
-(BOOL)saveContext;
-(id)searchOrGetNewObjectForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
-(NSArray *)searchInDataBase:(NSPredicate *)searchPredicate andEntity:(NSString *)entity;
-(NSArray *)getAllAvailableDataInEntity:(NSString *)entity;
-(void)removeAllRowsFromTable: (NSString *) tableName;
- (id)insertNewObjectForEntity:(NSString *)entityName;

@end
