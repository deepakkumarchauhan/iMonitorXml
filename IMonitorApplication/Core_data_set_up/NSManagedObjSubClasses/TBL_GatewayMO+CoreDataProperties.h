//
//  TBL_GatewayMO+CoreDataProperties.h
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/25/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "TBL_GatewayMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TBL_GatewayMO (CoreDataProperties)

+ (NSFetchRequest<TBL_GatewayMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *all_on_status;
@property (nullable, nonatomic, copy) NSString *customer_id;
@property (nullable, nonatomic, copy) NSString *customer_name;
@property (nullable, nonatomic, copy) NSString *customer_password;
@property (nullable, nonatomic, copy) NSString *gateway_mode;
@property (nullable, nonatomic, copy) NSString *gateway_status;
@property (nullable, nonatomic, copy) NSString *local_ip;
@property (nullable, nonatomic, copy) NSString *mac_id;
@property (nullable, nonatomic, retain) NSSet<TBL_DeviceMO *> *gatewayToDevice;

@end

@interface TBL_GatewayMO (CoreDataGeneratedAccessors)

- (void)addGatewayToDeviceObject:(TBL_DeviceMO *)value;
- (void)removeGatewayToDeviceObject:(TBL_DeviceMO *)value;
- (void)addGatewayToDevice:(NSSet<TBL_DeviceMO *> *)values;
- (void)removeGatewayToDevice:(NSSet<TBL_DeviceMO *> *)values;

@end

NS_ASSUME_NONNULL_END
