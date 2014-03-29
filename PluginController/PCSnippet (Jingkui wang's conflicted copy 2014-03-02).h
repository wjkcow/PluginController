//
//  PCSnippet.h
//  PluginController
//
//  Created by Jingkui Wang on 1/2/14.
//  Copyright (c) 2014 Jingkui Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCSnippet : NSObject
//Do assume snippet is installed
+ (void) run;
+ (void) showWelcomeMessage;
+ (NSMutableDictionary*) dictFromFile:(NSString *) path;
+ (void) writeDict: (NSMutableDictionary*) dict ToFile:(NSString *) path;
@end
