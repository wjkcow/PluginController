//
//  PluginController.m
//  PluginController
//
//  Created by Jingkui Wang on 12/25/13.
//  Copyright (c) 2013 Jingkui Wang. All rights reserved.
//

#import "PluginController.h"
#import "PConstants.h"
#import "PCHttp.h"
#import "PluginInfo.h"
#import "PCfileMag.h"
#import "PCSnippet.h"
#import <string>
#import <objc/runtime.h>
#include <iostream>

@implementation PluginController


- (id) init{
    self = [super init];
    if (self) {
        _installedPlugins = [NSMutableDictionary new];
        _file = [[NSArray alloc] init];
        NSString *homeDir = NSHomeDirectory();
        NSString *cfgPath = [homeDir stringByAppendingString:cfgPathEnd];
        if ([[NSFileManager defaultManager] fileExistsAtPath: cfgPath]) {
            NSLog(@"%@ found", cfgPath);
            [self loadPlist];
        } else {
            NSLog(@"%@ not found", cfgPath);
            [self savePlist];
            [self installPathogen];
            [self initVimrc];
            
        }
    }
    return self;
}

- (void) savePlist{
    NSString *errorMsg = nil;
    NSString *homeDir = NSHomeDirectory();
    NSString *cfgPath = [homeDir stringByAppendingString:cfgPathEnd];
    NSMutableDictionary *plistDict = [NSMutableDictionary new];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            NSLog(@"saving %@ ", propertyName);
            if([propertyName isNotEqualTo: @"installedPlugins"]){
                [plistDict setObject: [self valueForKey:propertyName] forKey:propertyName];
            } else {
                NSLog(@"Converting to array");
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                for (NSString *item in _installedPlugins) {
                    [dict setObject:[[_installedPlugins valueForKey:item] array] forKey:item];
                }
                [plistDict setObject: dict forKey:propertyName];
            }
        }
    }
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&errorMsg];
    [plistData writeToFile:cfgPath atomically:YES];
    NSLog(@"file written to path%@", cfgPath);
}

- (void) loadPlist{
    NSString *errorMsg = @"load cfg plist fail";
    NSPropertyListFormat format;
    NSString *homeDir = NSHomeDirectory();
    NSString *cfgPath = [homeDir stringByAppendingString:cfgPathEnd];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cfgPath]) {
        throw errorMsg;
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:cfgPath];
    NSDictionary *plistDict = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorMsg];
    if (!plistDict) {
        NSLog(@"Error reading plist: %@, format: %lu", errorMsg, format);
    }
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            NSLog(@"setting %@ ", propertyName);
            
            if([propertyName isNotEqualTo: @"installedPlugins"]){
                [self setValue:[plistDict objectForKey: propertyName] forKey:propertyName];
            }else {
                NSLog(@"Converting from array");
                NSMutableDictionary *dict = [plistDict objectForKey: propertyName];
                for (NSString *item in dict) {
                    [_installedPlugins setObject:[[PluginInfo alloc] initWithArray:[dict valueForKey:item]] forKey:item];
                }
            }
        }
    }
}

-(void) showWelcomeMessage{
    std::cout<<"************************************************************"<<std::endl
             <<"************************************************************"<<std::endl
             <<"                  VIM PLUGIN CONTROLLER                     "<<std::endl
             <<"          This is a plugin controller for Vim               "<<std::endl
             <<"commands:                                                   "<<std::endl
             <<"    search  [plugin name]:  Search for plugin               "<<std::endl
             <<"    install [plugin name]: Install plugin                   "<<std::endl
             <<"    remove : remove plugin                                  "<<std::endl
             <<"    list: list installed plugin                             "<<std::endl
             <<"    Enable  [plugin name]:  Enable plugin                   "<<std::endl
             <<"    Disable [plugin name]: Disable plugi                    "<<std::endl
             <<"    quit: quit this program                                 "<<std::endl
             <<"    help: show help message                                 "<<std::endl
             <<"************************************************************"<<std::endl
             <<"************************************************************"<<std::endl;
}
- (NSDictionary *) search: (NSString *) name{
    NSDictionary *searchResult = [PCHttp search: name];
    for (NSString *ids in searchResult) {
        PluginInfo *item = [searchResult objectForKey:ids];
        [item PrintItemInstall];
    }
    return searchResult;
}
- (void) install: (NSString *) name{
    NSDictionary *items = [self search:name];
    std::cout << "Type in the id of plugin to install" << std::endl;
    int id_int;
    std::cin >> id_int;
    NSNumber *id_pc = [[NSNumber alloc] initWithInt:id_int];
    
    PluginInfo *item = [items objectForKey: [id_pc stringValue]];
    if (item == nil) {
        NSLog(@"Error: id not found");
    } else {
        NSLog(@"Url to clone is: %@", [item address]);
        NSLog(@"Dir to clone is: %@", [item directory]);
        if([[NSFileManager defaultManager] fileExistsAtPath:[item directory]]){
            NSLog(@"Path Exist");
        } else {
            NSLog(@"Clone begin");
            [NSTask launchedTaskWithLaunchPath:git arguments:@[gitArgu,
                                            [item address], [item directory]]];
            NSLog(@"Task started");
            [_installedPlugins setObject:item forKey:[id_pc stringValue]];
            [self savePlist];
        }
    }
}
- (void) remove{
    [self list];
    std::cout<<"Type in id for remove"<<std::endl;
    int id_int;
    std::cin >> id_int;
    NSNumber *id_pc = [[NSNumber alloc] initWithInt:id_int];
    PluginInfo *item = [_installedPlugins objectForKey: [id_pc stringValue]];
    if([[NSFileManager defaultManager] fileExistsAtPath:[item directory]]){
        NSLog(@"Path Exist");
        [NSTask launchedTaskWithLaunchPath:rm arguments:@[rmArgu, [item directory]]];
        [_installedPlugins  removeObjectForKey:[id_pc stringValue]];
        [self savePlist];
    } else {
        NSLog(@"Path not Exist");

    }
}

- (void) list{
    for(NSString *item in _installedPlugins){
        [[_installedPlugins objectForKey:item] printItem];
    }
}
- (void) Enable{
    [self list];
    std::cout<<"Type in id for Enable"<<std::endl;
    int id_int;
    std::cin >> id_int;
    NSNumber *id_pc = [[NSNumber alloc] initWithInt:id_int];
    PluginInfo *item = [_installedPlugins objectForKey: [id_pc stringValue]];
    [self Enable: [item directory]];
}
- (void) Disable{
    [self list];
    std::cout<<"Type in id for Disable"<<std::endl;
    int id_int;
    std::cin >> id_int;
    NSNumber *id_pc = [[NSNumber alloc] initWithInt:id_int];
    PluginInfo *item = [_installedPlugins objectForKey: [id_pc stringValue]];
    [self Disable: [item directory]];

}

- (void) installPathogen{
    NSLog(@"Install Pathogen");
    NSString *homeDir = NSHomeDirectory();
    NSString *autoldPath = [homeDir stringByAppendingString: autoldPathEnd];
    [[NSFileManager defaultManager] createDirectoryAtPath:autoldPath withIntermediateDirectories:YES attributes:nil error: nil];
    
    NSString *pathogenPath = [homeDir stringByAppendingString: pathogenPathEnd];
  
    NSURL *pathogenUrl =  [[NSURL alloc] initWithString: @"http://github.com/vim-scripts/pathogen.vim/raw/master/plugin/pathogen.vim"];
    NSData *pathogenVim = [[NSData alloc] initWithContentsOfURL:pathogenUrl];
    [[NSFileManager defaultManager] createFileAtPath:pathogenPath contents:pathogenVim attributes:nil];
    
}
- (void) initVimrc{
    NSString *homeDir = NSHomeDirectory();
    NSString *vimrcPath = [homeDir stringByAppendingString: vimrcPathEnd];
    [[NSFileManager defaultManager] createFileAtPath:vimrcPath contents:[initVimrc dataUsingEncoding:NSASCIIStringEncoding] attributes:nil];

}

- (void) snippet{
    id dict = [PCSnippet dictFromFile:@"/Users/wjkcow/test/cpp.snippets"];
    [PCSnippet writeDict:dict ToFile:@"/Users/wjkcow/test/cpp.snippets"];
    
}


- (void) test{
    [self snippet];
    
    
}
- (void) Enable: (NSString *) path{
    [NSFileManager defaultManager];
    path = [path stringByAppendingString:@"/"];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for(NSString *file in files){
        NSString *newPath = [path stringByAppendingString:file];
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:newPath isDirectory: &isDir];
        if (isDir && (![[newPath pathExtension] isEqualToString:@"git"]) && (
                                                                             ![[newPath pathExtension] isEqualToString:@"DS_Store"])) {
            NSLog(@"go into path%@",
                  newPath);
            [self Enable:newPath];
        } else{
            if ([[newPath pathExtension] isEqualToString:@"disable"]) {
                NSLog(@"find file%@", newPath);
                std::string newNamestr([newPath UTF8String]);
                newNamestr.erase(newNamestr.end() - 8, newNamestr.end());
                NSString *newName = [[NSString alloc] initWithUTF8String:newNamestr.c_str()];
                [[NSFileManager defaultManager] movePath:newPath toPath:newName handler:nil];
            }
        }
        
    }
}

- (void) Disable: (NSString *) path{
    [NSFileManager defaultManager];
    path = [path stringByAppendingString:@"/"];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for(NSString *file in files){
        NSString *newPath = [path stringByAppendingString:file];
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:newPath isDirectory: &isDir];
        if (isDir && (![[newPath pathExtension] isEqualToString:@"git"]) && (
            ![[newPath pathExtension] isEqualToString:@"DS_Store"])) {
            NSLog(@"go into path%@",
                  newPath);
            [self Disable:newPath];
        } else{
            if ([[newPath pathExtension] isEqualToString:@"vim"]) {
                NSLog(@"find file%@", newPath);
                NSString *newName = [newPath stringByAppendingString: @".disable"];
                [[NSFileManager defaultManager] movePath:newPath toPath:newName handler:nil];
            }
        }
        
    }
}

@end
