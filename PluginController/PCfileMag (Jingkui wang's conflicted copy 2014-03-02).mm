//
//  PCfileMag.m
//  PluginController
//
//  Created by Jingkui Wang on 12/30/13.
//  Copyright (c) 2013 Jingkui Wang. All rights reserved.
//

#import "PCfileMag.h"
#import <string.h>
#import <iostream>
#import <sstream>
@implementation PCfileMag
+ (void) test{
    NSMutableArray * rtrnArray;
    NSString *path = @"/Users/wjkcow/test/test.vim";
    NSString *file = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    NSArray *split = [file componentsSeparatedByString: @"\"###"];
    file = nil;
    NSMutableArray *myContent = [split[1] componentsSeparatedByString:@"\"$$$"];
    split = nil;
    [myContent removeObjectAtIndex:0];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (NSString *item in myContent) {
      //  NSLog(@"%@ item ", item);
        NSArray *fields = [item componentsSeparatedByString:@"\"@@@"];
        NSUInteger count = [fields count];
        NSString *tag = [self getTag:fields[0]];
        NSMutableArray *items = [NSMutableArray new];
        for (NSUInteger i = 1; i < count; i += 2) {
            NSString *type = [self getType:fields[i]];
            NSString *content = fields[i + 1];
            const char *c = ([content cStringUsingEncoding: NSASCIIStringEncoding] + 1);
            while (*c == ' ' || *c == '\n') {
                c++;
            }
            content = [[NSString alloc] initWithCString:c  encoding:NSASCIIStringEncoding];
            NSArray *oneItem = @[type, content];
            [items addObject:oneItem];
        }
        [dict setObject:items forKey:tag];
        [rtrnArray addObject:split[2]];
     //   NSLog(@"%@..%@", tagField[0],tagField[1]);
    }
    
    
}



+ (void) writeToPath: (NSString *) path fromDict: (NSDictionary *) dict{

}
+ (NSArray *) getFromPath: (NSString *) path{
    NSMutableArray * rtrnArray = [NSMutableArray new];
    NSString *file = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    NSArray *split = [file componentsSeparatedByString: @"\"###"];
    file = nil;
    NSMutableArray *myContent = [split[1] componentsSeparatedByString:@"\"$$$"];
    [myContent removeObjectAtIndex:0];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (NSString *item in myContent) {
        //  NSLog(@"%@ item ", item);
        NSArray *fields = [item componentsSeparatedByString:@"\"@@@"];
        NSUInteger count = [fields count];
        NSString *tag = [self getTag:fields[0]];
        NSMutableArray *items = [NSMutableArray new];
        for (NSUInteger i = 1; i < count; i += 2) {
            NSString *type = [self getType:fields[i]];
            NSString *content = fields[i + 1];
            const char *c = ([content cStringUsingEncoding: NSASCIIStringEncoding] + 1);
            while (*c == ' ' || *c == '\n') {
                c++;
            }
            content = [[NSString alloc] initWithCString:c  encoding:NSASCIIStringEncoding];
            NSArray *oneItem = @[type, content];
            [items addObject:oneItem];
        }
        [dict setObject:items forKey:tag];
                //   NSLog(@"%@..%@", tagField[0],tagField[1]);
    }
    [rtrnArray addObject:dict];
    [rtrnArray addObject:split[2]];
    return rtrnArray;
}
+ (NSString *) getTag: (NSString *) raw{
   /* NSMutableArray *returnValue = [NSMutableArray new];
    NSString *tag;
    NSNumber *fieldNumber;
    std::stringstream sstream([raw cStringUsingEncoding:NSASCIIStringEncoding]);
    std::string tmp;
    int tmpi;
    sstream >> tmp >> tmpi;
    tag = [[NSString alloc] initWithUTF8String:tmp.c_str()];
    fieldNumber = [[NSNumber alloc] initWithInt:tmpi];
    [returnValue addObject:tag];
    [returnValue addObject:fieldNumber];
    return returnValue;*/
    return [self getType:raw];
};
+ (NSString *) getType: (NSString *) raw{
    NSString *returnValue;
    std::stringstream sstream([raw cStringUsingEncoding:NSASCIIStringEncoding]);
    std::string tmp;
    sstream >> tmp;
    returnValue = [[NSString alloc] initWithUTF8String:tmp.c_str()];
    return returnValue;
}
@end

