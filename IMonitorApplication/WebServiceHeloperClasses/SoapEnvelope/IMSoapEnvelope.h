//
//  IMSoapEnvelope.h
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/15/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMSoapEnvelope : NSObject

+ (NSString *)loginUserWithDictionary:(NSMutableDictionary *)userInfoDict;
+ (NSString *)forgotPasswordWithCustomerID:(NSString *)customerID andUserID:(NSString *)strUserID;
+ (NSString *)getDeviceDetailsRequestWithDict:(NSMutableDictionary *)userInfoDict;
+ (NSString *)getNotificationListRequestWithDict:(NSMutableDictionary *)userInfoDict;
@end
