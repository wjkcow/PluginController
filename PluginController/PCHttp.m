//
//  PCHttp.m
//  PluginController
//
//  Created by Jingkui Wang on 12/29/13.
//  Copyright (c) 2013 Jingkui Wang. All rights reserved.
//

#import "PCHttp.h"
#import "PluginInfo.h"
@implementation PCHttp

+ (NSMutableDictionary *) search: (NSString *) name{
    NSMutableDictionary *searchResult = [NSMutableDictionary new];
    
    NSString *urlStr = [NSString stringWithFormat:
                     @"https://api.github.com/search/repositories?q=%@+language:VimL", name];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *searchResultData = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    if (searchResultData == nil) {
        NSLog(@"No result");
    }
    NSNumber *total_count = [searchResultData objectForKey:@"total_count"];
    NSLog(@"total count of search result %@", total_count);
    NSArray *items = [searchResultData objectForKey:@"items"];
    for (NSDictionary *item in items) {
        NSNumber *id_pc = [item objectForKey:@"id"];
        NSString *name = [item objectForKey: @"name"];
        NSString *address = [item objectForKey: @"clone_url"];
        NSString *description = [item objectForKey: @"description"];
        if (![description isKindOfClass:[NSString class]]) {
            description = @"No description";
        }
        NSLog(@"%@", description);
        NSString *homeDir = NSHomeDirectory();
        NSString *bundlePath = [homeDir stringByAppendingString: @"/.vim/Bundle/"];
        NSString *directory = [bundlePath stringByAppendingString:name];
        [[[PluginInfo alloc] initWithID:id_pc name:name address:address directory:directory description:description] printItem];
        [searchResult setValue:[[PluginInfo alloc] initWithID:id_pc name:name address:address directory:directory description:description]  forKey:[id_pc stringValue]];

    }
    return searchResult;
}

@end
