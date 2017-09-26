//
//  TBL_GatewayMO+CoreDataProperties.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/25/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "TBL_GatewayMO+CoreDataProperties.h"

@implementation TBL_GatewayMO (CoreDataProperties)

+ (NSFetchRequest<TBL_GatewayMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TBL_Gateway"];
}

@dynamic all_on_status;
@dynamic customer_id;
@dynamic customer_name;
@dynamic customer_password;
@dynamic gateway_mode;
@dynamic gateway_status;
@dynamic local_ip;
@dynamic mac_id;
@dynamic gatewayToDevice;

@end
