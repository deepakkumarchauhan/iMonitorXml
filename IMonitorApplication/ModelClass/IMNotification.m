//
//  IMNotification.m
//  IMonitorApplication
//
//  Created by Deepak Chauhan on 08/09/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMNotification.h"
#import "NSDictionary+NullChecker.h"

@implementation IMNotification

+ (IMNotification*)parseNotificationListData:(NSDictionary *)dict {
    
    IMNotification *tempObj = [[IMNotification alloc] init];
    tempObj.alarmName = [dict objectForKeyNotNull:@"aNm" expectedObj:@""];
    tempObj.alarmTime = [dict objectForKeyNotNull:@"iAT" expectedObj:@""];
    tempObj.deviceName = [dict objectForKeyNotNull:@"dNm" expectedObj:@""];
    tempObj.timeDifference = [dict objectForKeyNotNull:@"tDf" expectedObj:@""];

    return tempObj;
}

@end
