//
//  IMServiceHelper.h
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/18/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^IMServiceRequestResponseBlock)(id result,  NSError  *error);

typedef enum RequestHTTPMethodType {
    post = 0,
    get,
    put
} RequestHTTPMethodType;

typedef enum APIName {
    loginAPI = 0,
    forgotPasswordAPI,
    synchronizegatewaydetails,
    notificationListAPI

} APIName;

@interface IMServiceHelper : NSObject

+(id)sharedServiceHelper;
-(void)cancelRequestSession;

// use to call  apis
-(void)webAPICallWithSoapRequest:(NSString *)requestString httpMethodType:(RequestHTTPMethodType)type apiName:(APIName)apiName controller:(UIViewController *)controller withComptionBlock:(IMServiceRequestResponseBlock)block;


@end
