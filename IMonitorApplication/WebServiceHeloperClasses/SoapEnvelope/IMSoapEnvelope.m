//
//  IMSoapEnvelope.m
//  IMonitorApplication
//
//  Created by Ratneshwar Singh on 9/15/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "IMSoapEnvelope.h"
#import "Macro.h"
#import "NSDictionary+NullChecker.h"

@interface NSMutableString (SOAPAddition)

-(void)addSOAPValue:(NSString*)value forKey:(NSString*)key;

@end

@implementation NSMutableString (SOAPAddition)

-(void)addSOAPValue:(NSString*)value forKey:(NSString*)key {
    
    //    if (value && ([value length]>0) && key && ([key length]>0))
    //        [self appendFormat:@"<%@>%@</%@>",key,value,key];
    
    if (value && ([value length]>0) && key && ([key length]>0)) {
        
        if (([value rangeOfString:@"<"].length == 1) && ([value rangeOfString:@"<"].location == 0)) {
            [self appendFormat:@"<%@>%@</%@>",key,value,key];
        }
        else {
            
            NSString *convertedVal = [value stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
            convertedVal = [convertedVal stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
            convertedVal = [convertedVal stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
            convertedVal = [convertedVal stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
            convertedVal = [convertedVal stringByReplacingOccurrencesOfString:@"<" withString:@"&#39;"];
            
            [self appendFormat:@"<%@>",key];
            [self appendString:convertedVal];
            [self appendFormat:@"</%@>",key];
        }
    }
}

@end

@implementation IMSoapEnvelope

+(NSString *)getWrappedRequestWith:(NSString*)soapReq {
    
    return [NSString stringWithFormat:@"<?xml version=\'1.0\' encoding=\'utf-8\'?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body>%@</soap:Body></soap:Envelope>",soapReq];
}

//+(NSString *)getWrappedRequestWith:(NSString*)soapReq {
//    
//    return [NSString stringWithFormat:@"<?xml version=\'1.0\' encoding=\'utf-8\'?><soap:Body>%@</soap:Body>",soapReq];
//}


//
+(NSString*)getSOAPRequestForAPI:(NSString*)apiName withRequest:(NSString*)soapreq {
    return [self getWrappedRequestWith:[NSString stringWithFormat:@"<%@ xmlns=\"https://secureclub.net/poswebservices/\">%@</%@>",apiName,soapreq,apiName]];
}

//+(NSString *)getWrappedRequestWith:(NSString*)soapReq {
//    
//    return [NSString stringWithFormat:@"<?xml version=\'1.0\' encoding=\'utf-8\'?>%@",soapReq];
//}

+(NSString*)getSOAPRequestWithRequestString:(NSString*)soapreq {
    return [self getWrappedRequestWith:soapreq];
}


/**
 Creates request for Login

 @param userInfoDict dictionaryWithRequest Params
 @return XML String
 */
+ (NSString *)loginUserWithDictionary:(NSMutableDictionary *)userInfoDict {
    
    NSMutableString *requestStr = [NSMutableString string];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"customerid" expectedObj:@""] forKey:@"customerid"];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"userid" expectedObj:@""] forKey:@"userid"];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"password" expectedObj:@""] forKey:@"password"];
    return [self getSOAPRequestWithRequestString:[NSString stringWithFormat:@"<imonitor>%@</imonitor>",requestStr]];
}

//Request generation for forgot password
+ (NSString *)forgotPasswordWithCustomerID:(NSString *)customerID andUserID:(NSString *)strUserID{
    
    NSMutableString *requestStr = [NSMutableString string];
    [requestStr addSOAPValue:customerID forKey:@"customerid"];
     [requestStr addSOAPValue:strUserID forKey:@"userid"];
    return [self getSOAPRequestWithRequestString:[NSString stringWithFormat:@"<imonitor>%@</imonitor>",requestStr]];
}

//Request generation for device details
+ (NSString *)getDeviceDetailsRequestWithDict:(NSMutableDictionary *)userInfoDict {
    
    NSMutableString *requestStr = [NSMutableString string];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"customer" expectedObj:@""] forKey:@"customer"];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"userid" expectedObj:@""] forKey:@"userid"];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"password" expectedObj:@""] forKey:@"password"];
    return [self getSOAPRequestWithRequestString:[NSString stringWithFormat:@"<imonitor>%@</imonitor>",requestStr]];
}

//Request generation for device details
+ (NSString *)getNotificationListRequestWithDict:(NSMutableDictionary *)userInfoDict {
    
    NSMutableString *requestStr = [NSMutableString string];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"customer" expectedObj:@""] forKey:@"customer"];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"userid" expectedObj:@""] forKey:@"userid"];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"password" expectedObj:@""] forKey:@"password"];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"macid" expectedObj:@""] forKey:@"macid"];
    [requestStr addSOAPValue:[userInfoDict objectForKeyNotNull:@"timeStamp" expectedObj:@""] forKey:@"timeStamp"];
    return [self getSOAPRequestWithRequestString:[NSString stringWithFormat:@"<imonitor>%@</imonitor>",requestStr]];
}

@end
