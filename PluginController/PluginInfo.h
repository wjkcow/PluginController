//
//  PluginInfo.h
//  PluginController
//
//  Created by Jingkui Wang on 12/25/13.
//  Copyright (c) 2013 Jingkui Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PluginInfo : NSObject
@property BOOL isEnable;
@property (copy) NSNumber *id_pc;
@property (copy) NSString *name;
@property (copy) NSString *address;
@property (copy) NSString *directory;
@property (copy) NSString *description;
- (id) initWithID: (NSNumber *) id_pc name: (NSString *) name
          address: (NSString *) address directory: (NSString *) directory
      description: (NSString *) description;
- (id) initWithID: (NSNumber *) id_pc name: (NSString *) name
          address: (NSString *) address
      description: (NSString *) description;
- (id) initWithArray: (NSArray *) array;
- (NSArray *) array;
- (void) printItem;
- (void) PrintItemInstall;
@end
