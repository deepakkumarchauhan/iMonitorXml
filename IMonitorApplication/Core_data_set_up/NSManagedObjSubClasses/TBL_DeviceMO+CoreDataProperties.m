//
//  TBL_DeviceMO+CoreDataProperties.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/25/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "TBL_DeviceMO+CoreDataProperties.h"

@implementation TBL_DeviceMO (CoreDataProperties)

+ (NSFetchRequest<TBL_DeviceMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TBL_Device"];
}

@dynamic armstatus;
@dynamic batteryLevel;
@dynamic device_position;
@dynamic deviceConfig;
@dynamic enableStatus;
@dynamic icon;
@dynamic idDevice;
@dynamic left;
@dynamic levelStatus;
@dynamic lIcon;
@dynamic location;
@dynamic mac_id;
@dynamic modelNumber;
@dynamic name;
@dynamic status;
@dynamic top;
@dynamic type;

@end
