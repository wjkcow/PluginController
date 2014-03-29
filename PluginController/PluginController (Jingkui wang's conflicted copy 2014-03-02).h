//
//  PluginController.h
//  PluginController
//
//  Created by Jingkui Wang on 12/25/13.
//  Copyright (c) 2013 Jingkui Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PluginController : NSObject
@property NSMutableDictionary *installedPlugins;
@property NSArray * file;
- (id) init;

- (void) savePlist;
- (void) loadPlist;

- (void) showWelcomeMessage;
- (NSDictionary *) search: (NSString *) name;
- (void) install: (NSString *) name;
- (void) remove;
- (void) list;
- (void) Enable;
- (void) Disable;
- (void) installPathogen;
- (void) initVimrc;

- (void) snippet;

- (void) test;
@end
