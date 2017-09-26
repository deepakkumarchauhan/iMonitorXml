//
//  TBL_DeviceMO+CoreDataProperties.h
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/25/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "TBL_DeviceMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TBL_DeviceMO (CoreDataProperties)

+ (NSFetchRequest<TBL_DeviceMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *armstatus;
@property (nullable, nonatomic, copy) NSString *batteryLevel;
@property (nullable, nonatomic, copy) NSString *device_position;
@property (nullable, nonatomic, copy) NSString *deviceConfig;
@property (nullable, nonatomic, copy) NSString *enableStatus;
@property (nullable, nonatomic, copy) NSString *icon;
@property (nullable, nonatomic, copy) NSString *idDevice;
@property (nullable, nonatomic, copy) NSString *left;
@property (nullable, nonatomic, copy) NSString *levelStatus;
@property (nullable, nonatomic, copy) NSString *lIcon;
@property (nullable, nonatomic, copy) NSString *location;
@property (nullable, nonatomic, copy) NSString *mac_id;
@property (nullable, nonatomic, copy) NSString *modelNumber;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *status;
@property (nullable, nonatomic, copy) NSString *top;
@property (nullable, nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
