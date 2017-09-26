//
//  NSDictionary+NullChecker.h
//  PartyApp
//
//  Created by KrishnaKant kaira on 04/03/14.
//  Copyright (c) 2014 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NullChecker)

-(id)objectForKeyNotNull:(id)object expectedObj:(id)obj;

//New update in clas
-(id)objectForKeyNotNull:(id)key expectedClass:(Class)className;

//new method added for project specific use (Active Club)
-(id)getTextValueForKey:(NSString*)key;

@end
