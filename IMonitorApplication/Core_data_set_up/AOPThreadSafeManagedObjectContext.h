//
//  AOPThreadSafeManagedObjectContext.h
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/21/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface AOPThreadSafeManagedObjectContext : NSManagedObjectContext {
    NSThread* myThread;
}

@end
