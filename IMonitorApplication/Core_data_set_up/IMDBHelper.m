//
//  IMDBHelper.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/21/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMDBHelper.h"


@implementation IMDBHelper
static  IMDBHelper *singleton = nil;


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (id)instance {
    @synchronized(self) {
        if(!singleton)
            singleton = [[IMDBHelper alloc] init];
    }
    return singleton;
}


-(BOOL)saveContext{
    NSError *error = nil;
    return [[self managedObjectContext] save:&error];;
}

-(void)deleteItemFromContext:(id)sender {
    
    [self.managedObjectContext deleteObject:sender];
}


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[AOPThreadSafeManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IMonitorModel" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:path];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    
    return managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"AOPDBModel.sqlite"]];
    
    // handle db upgrade
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle error
    }
    
    return persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory
/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark - Other utitily methods

-(id)searchOrGetNewObjectForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
    
    id searchedObject = [self searchInDataBase:predicate andEntity:entityName];
    if (searchedObject == nil)
        searchedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    else
        searchedObject = [searchedObject firstObject];
    
    return searchedObject;
}


/**
 Insert object in database without any searching

 @param entityName Entity Name for which creation should be done
 @return created object
 */
- (id)insertNewObjectForEntity:(NSString *)entityName {
    
    id createdObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    return createdObject;
}


-(NSArray *)searchInDataBase:(NSPredicate *)searchPredicate andEntity:(NSString *)entity {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:[self managedObjectContext]]];
    if(searchPredicate)
        [request setPredicate:searchPredicate];
    
    NSError *error = nil;
    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if([array count]){
        return array;
    }
    
    return nil;
}

- (NSArray *)getAllAvailableDataInEntity:(NSString *)entity {
    return [self searchInDataBase:Nil andEntity:entity];
}

//Delete Object for Entity
- (void)removeAllRowsFromTable: (NSString *) tableName  {
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [moc executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [moc deleteObject:managedObject];
        //    	NSLog(@"%@ object deleted",tableName);
    }
    if (![moc save:&error]) {
        //    	NSLog(@"Error deleting %@ - error:%@",tableName,error);
    }
}
@end
