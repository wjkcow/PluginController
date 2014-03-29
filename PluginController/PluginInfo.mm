//
//  PluginInfo.m
//  PluginController
//
//  Created by Jingkui Wang on 12/25/13.
//  Copyright (c) 2013 Jingkui Wang. All rights reserved.
//

#import "PluginInfo.h"
#include <iostream>
@implementation PluginInfo

- (id) initWithArray: (NSArray *) array{
    self = [super init];
    if (self) {
        if ([array[0] isEqualToString:@"Yes"]) {
            _isEnable = YES;
        } else {
            _isEnable = NO;
        }
        _id_pc = array[1];
        _name  = array[2];
        _address = array[3];
        _directory = array[4];
        _description = array[5];
        NSLog(@"initWithArray%@", _id_pc);
    }
    return self;
}
- (NSArray *) array{
    return @[(_isEnable?@"Yes":@"No"), _id_pc, _name, _address, _directory, _description];
}
- (id) initWithID: (NSNumber *) id_pc name: (NSString *) name
          address: (NSString *) address directory: (NSString *) directory
      description: (NSString *) description{
    self = [super init];
    if (self) {
        _isEnable = YES;
        _id_pc = id_pc;
        _name = name;
        _address = address;
        _directory = directory;
        _description = description;
    }
    return self;
}
- (id) initWithID: (NSNumber *) id_pc name: (NSString *) name
          address: (NSString *) address
      description: (NSString *) description{
    return [self initWithID:id_pc name:name address:address directory:nil description:description];
}
-(void)printItem{
    std::cout<<"########################################"<<std::endl;
    std::string name_str([_name UTF8String]);
    std::string description_str([_description UTF8String]);
    std::cout << "ID: "<< [[_id_pc stringValue] UTF8String] <<std::endl;
    std::cout << "Enable: "<< (_isEnable?"Yes":"No ") <<std::endl;
    std::cout << "Name: " << name_str << std::endl;
    std::cout << "Description: " << description_str << std::endl;

}
-(void)PrintItemInstall{
    std::cout<<"########################################"<<std::endl;
    std::string name_str([_name UTF8String]);
    std::string description_str([_description UTF8String]);
    std::cout << "ID: "<< [[_id_pc stringValue] UTF8String] <<std::endl;
    std::cout << "Name: " << name_str << std::endl;
    std::cout << "Description: " << description_str << std::endl;
}
@end
