//
//  PCfileMag.h
//  PluginController
//
//  Created by Jingkui Wang on 12/30/13.
//  Copyright (c) 2013 Jingkui Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCfileMag : NSObject
+ (void) test;
+ (void) writeToPath: (NSString *) path fromArray: (NSArray *) arry;
+ (NSArray *) getFromPath: (NSString *) path;
@end
