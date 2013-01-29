//
//  CRCSaveRequest.h
//  CocoaRestClient
//
//  Created by Adam Venturella on 7/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaRestClientAppDelegate.h"

@interface CRCRequest : NSObject <NSCoding>

@property BOOL rawRequestInput;
@property(nonatomic, copy) NSString * name;
@property(nonatomic, copy) NSString * url;
@property(nonatomic, copy) NSString * method;
@property(nonatomic, copy) NSString * requestText;
@property(nonatomic, copy) NSString * username;
@property(nonatomic, copy) NSString * password;
@property(nonatomic, copy) NSArray * headers;
@property(nonatomic, copy) NSArray * files;
@property(nonatomic, copy) NSArray * params;

+ (CRCRequest *)requestWithApplication:(CocoaRestClientAppDelegate *)application;
@end
