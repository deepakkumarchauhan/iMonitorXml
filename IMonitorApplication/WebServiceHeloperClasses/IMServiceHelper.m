//
//  IMServiceHelper.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/18/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMServiceHelper.h"
#import "Macro.h"
#import "XMLReader.h"
#import "MBProgressHUD.h"
#import "Macro.h"
#import "AppDelegate.h"
#import "IMAppUtility.h"

@interface IMServiceHelper()<NSURLSessionDelegate, NSURLSessionTaskDelegate> {
    
    NSURLSession *requestSessionObj;
}

@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) UIViewController *controllerClass;

@end

static IMServiceHelper *serviceHelper = nil;

@implementation IMServiceHelper

+(id)sharedServiceHelper {
    
    if (!serviceHelper) {
        serviceHelper = [[IMServiceHelper alloc] init];
    }
    return serviceHelper;
}

-(void)cancelRequestSession {
    [requestSessionObj invalidateAndCancel];
}

-(void)webAPICallWithSoapRequest:(NSString *)requestString httpMethodType:(RequestHTTPMethodType)type apiName:(APIName)apiName controller:(UIViewController *)controller withComptionBlock:(IMServiceRequestResponseBlock)block {
    
    IMServiceRequestResponseBlock completionBlock = [block copy];
    AppDelegate *appDelegateObj = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([appDelegateObj isReachable]) {
        
        NSMutableString *urlString = [NSMutableString string];
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestString length]];
        
        NSString *urlToHit = [NSString stringWithFormat:@"%@%@",[NSUSERDEFAULT valueForKey:kSerivceBaseURL],[self getAPINameFromWebMethodType:apiName]];
        urlString = [NSMutableString stringWithString:urlToHit];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        switch (type) {
            case post:
                [request setHTTPMethod:@"POST"];
                break;
            case put:
                [request setHTTPMethod:@"PUT"];
                break;
            case get:
                [request setHTTPMethod:@"GET"];
                break;
            default:
                [request setHTTPMethod:@"POST"];
                break;
        }
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:[[NSString stringWithFormat:@"data=%@",requestString] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (!requestSessionObj) {
            NSURLSessionConfiguration *sessionConfig =  [NSURLSessionConfiguration defaultSessionConfiguration];
            [sessionConfig setTimeoutIntervalForRequest:45.0];
            requestSessionObj = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        }
        
        self.controllerClass = controller;
        if (self.controllerClass) {
            [self removeProgressHUDFromController:self.controllerClass];
            [self addProgressHUDToController:self.controllerClass];
        }
        
        IMLog(@"\nREQUEST URL:=================\n%@\nREQUEST FORMAT:=================\n%@\n", urlToHit, requestString)
        
        [[requestSessionObj dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;

            if (!error) {
                
                NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *result = [XMLReader dictionaryForXMLString:responseStr error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(result,  error);
                    IMLog(@"ResultDict >>>>>>>>>>>>>>>%@\n ResponseCode>>>>>>>%ld\nError:>>>>>>> %@\nErrorDescription:%@ ",result,(long)[res statusCode],error, error.description)
                    [self removeProgressHUDFromController:self.controllerClass];
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil,  error);
                    IMLog(@"ResponseCode>>>>>>>%ld\nError:>>>>>>> %@\nErrorDescription:%@ ",(long)[res statusCode],error, error.description)
                    [self removeProgressHUDFromController:self.controllerClass];
                });
            }
        }] resume];
    }
    else {
        [IMAppUtility alertWithTitle:@"Error!" andMessage:NETWORK_UNREACHABLE_ERR andController:controller];
    }
}


#pragma mark NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
}

#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler {
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * __nullable bodyStream))completionHandler {
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
}


/**
 This method is being used to complete the url in request

 @param methodType apiName Enum
 @return String of type
 */
- (NSString *)getAPINameFromWebMethodType:(APIName)methodType {
    
    NSString *strAPIName = @"";
    switch (methodType) {
        case loginAPI:
            strAPIName = @"mobile/login.action";
            break;
        case forgotPasswordAPI:
            strAPIName = @"mid/ForgotPassword.action";
            break;
        case synchronizegatewaydetails:
            strAPIName = @"mid/synchronizegatewaydetails.action";
            break;
        case notificationListAPI:
            strAPIName = @"mid/Alaram.action";
            break;
        default:
            break;
    }
    return strAPIName;
}

#pragma mark - **** Progress HUD Helper ****
-(void)addProgressHUDToController :(UIViewController*)controller {
    
    [MBProgressHUD hideAllHUDsForView:controller.view animated:YES];
    self.progressHUD = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    [self.progressHUD setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    [self.progressHUD setColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
}

-(void)removeProgressHUDFromController:(UIViewController*)controller {
    
    //handled from the controller class
    if (self.controllerClass)
        [MBProgressHUD hideAllHUDsForView:controller.view animated:YES];
    
    self.progressHUD = nil;
}


@end
