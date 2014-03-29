//
//  main.m
//  PluginController
//
//  Created by Jingkui Wang on 12/25/13.
//  Copyright (c) 2013 Jingkui Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PluginController.h"
#include <iostream>
#include <string>
int main(int argc, const char * argv[])
{

    @autoreleasepool {
        PluginController *plugin_controller = [[PluginController alloc] init];
        NSLog(@"Program begin!");
        [plugin_controller showWelcomeMessage];
        std::string command;
        std::string pluginNames;
        
        [plugin_controller test];
        std::cout << "$ ";
        std::cin >> command;
        while (command != "quit") {
            if(command == "search"){
                std::cin >> pluginNames;
                NSString *name = [[NSString alloc] initWithUTF8String:pluginNames.c_str()];
                [plugin_controller search:name];
            }
            else if(command == "install"){
                std::cin >> pluginNames;
                NSString *name = [[NSString alloc] initWithUTF8String:pluginNames.c_str()];
                [plugin_controller install:name];
            }
            else if(command == "remove"){
                [plugin_controller remove];
            }
            else if(command == "list"){
                [plugin_controller list];
            }
            else if(command == "Enable"){
                [plugin_controller Enable];
            }
            else if(command == "Disable"){
                [plugin_controller Disable];
            }
            else if(command == "snippet"){
                [plugin_controller snippet];
            }
            else if(command == "help"){
                [plugin_controller showWelcomeMessage];
            }
            else if(command == "test"){
                [plugin_controller test];
            }
            std::cout << "$ ";
            std::cin >> command;
        }
        NSLog(@"Program finish!");
        
    }
    return 0;
}

