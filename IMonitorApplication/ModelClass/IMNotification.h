//
//  IMNotification.h
//  IMonitorApplication
//
//  Created by Deepak Chauhan on 08/09/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMNotification : NSObject

@property (strong, nonatomic) NSString *deviceName;
@property (strong, nonatomic) NSString *alarmName;
@property (strong, nonatomic) NSString *alarmTime;
@property (strong, nonatomic) NSString *timeDifference;

+ (IMNotification*)parseNotificationListData:(NSDictionary *)dict;
@end
