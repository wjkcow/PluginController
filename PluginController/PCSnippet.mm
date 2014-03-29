//
//  PCSnippet.m
//  PluginController
//
//  Created by Jingkui Wang on 1/2/14.
//  Copyright (c) 2014 Jingkui Wang. All rights reserved.
//

#import "PCSnippet.h"
#include <string>
#include <iostream>
@implementation PCSnippet
+ (void) run{
    [self showWelcomeMessage];

}
+ (void) showWelcomeMessage{
    std::cout<<"************************************************************"<<std::endl
    <<"************************************************************"<<std::endl
    <<"                  VIM SNIPPET CONTROLLER                    "<<std::endl
    <<"          This is a Snippet controller for Vim              "<<std::endl
    <<"    Notice: do assume snippetMate is installed              "<<std::endl
    <<"commands:                                                   "<<std::endl
    <<"    show: show all snippet                                  "<<std::endl
    <<"    change: change a snippet                                "<<std::endl
    <<"    quit: quit this program                                 "<<std::endl
    <<"    help: show help message                                 "<<std::endl
    <<"************************************************************"<<std::endl
    <<"************************************************************"<<std::endl;

}
//new
+ (void)writeAllSnippet: (NSMutableArray *) dict{
    NSMutableArray *allSnippet = [NSMutableArray new];
    NSString *homeDir = NSHomeDirectory();
    for(NSArray *snipEntry in dict){
        NSString *mypath =  [NSString stringWithFormat:@"%@/.vim/bundle/snipMate/snippets/%@", homeDir, snipEntry[0]];
        [self writeDict:snipEntry[1] ToFile:mypath];
    }
    
}
//new
//new
+ (NSMutableArray *) getAllSnippet{
    NSMutableArray *allSnippet = [NSMutableArray new];
    NSString *homeDir = NSHomeDirectory();
    NSString *snippetDir = [NSString stringWithFormat:@"%@/.vim/bundle/snipMate/snippets", homeDir];
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:snippetDir error:nil];
    for (NSString *snipFile in files) {
        if ([[snipFile pathExtension] isEqualToString:@"snippets"]
            && [snipFile isNotEqualTo:@"_.snippets"]){
        NSString *path = [NSString stringWithFormat:@"%@/.vim/bundle/snipMate/snippets/%@", homeDir, snipFile];
        NSLog(@"%@",path);
        NSMutableDictionary *dict = [self dictFromFile:path];
            [allSnippet addObject:@[snipFile, dict]];
        }
    }
    return allSnippet;
}
//new
+ (NSMutableDictionary*) dictFromFile:(NSString *) path{
    NSMutableDictionary *rtrnValue = [NSMutableDictionary new];
    NSString *fileStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [fileStr componentsSeparatedByString:@"\n"];
    NSMutableArray *snippetComment = [NSMutableArray new];
    NSMutableArray *snippetContent = [NSMutableArray new];
    NSString *snippetName;
    for (NSString *line in lines) {
        if ([self ifSnippet:line]) {
           // NSLog(@"Snippet %@", line);
            if (snippetName != nil) {
                [rtrnValue setObject:@[snippetComment, [self getSnippetContent:snippetContent]] forKey:snippetName];
            }
            snippetComment = [NSMutableArray new];
            snippetContent = [NSMutableArray new];
            snippetName = [self getSnippetName:line];
        } else if([self ifComment:line]){
            //NSLog(@"Comment %@", line);
            [snippetComment addObject: [self getComment:line]];
        } else{
            [snippetContent addObject:line];
        }
    }
    if (snippetName != nil) {
        [rtrnValue setObject:@[snippetComment, [self getSnippetContent:snippetContent]] forKey:snippetName];
    }
    return rtrnValue;
}
//new
+ (void) writeDict: (NSMutableDictionary*) dict ToFile:(NSString *) path{
    NSLog(path);
    NSMutableString *content = [[NSMutableString alloc] init];
    for (NSString *key in dict) {
        NSArray *snippet = [dict objectForKey:key];
        if (snippet[0] != nil) {
            for (NSString *comment in snippet[0]) {
               // [content appendString:[NSString stringWithFormat:@"# %@\n",comment]];
            }
        }
        [content appendString:[NSString stringWithFormat:@"snippet %@\n",key]];
        NSArray *snippetContent = [snippet[1] componentsSeparatedByString:@"\n"];
        for (NSString *line in snippetContent){
            if([line length] != 0){
                [content appendString:[NSString stringWithFormat:@"\t%@\n",line]];
            }
        }
    }
    [content writeToFile:path atomically:YES encoding:NSASCIIStringEncoding error:nil];
}
//new

+ (NSString *) getComment: (NSString *) line{
    std::string lineStr([line cStringUsingEncoding:NSUTF8StringEncoding]);
    while (lineStr[0] == '#' || lineStr[0] == ' ' || lineStr[0] == '\t') {
        lineStr.erase(lineStr.begin());
    }
    return [[NSString alloc] initWithCString:lineStr.c_str() encoding:NSUTF8StringEncoding];
}

+ (NSString *) getSnippetName: (NSString *) line{
    std::string lineStr([line cStringUsingEncoding:NSUTF8StringEncoding]);
    lineStr.erase(lineStr.begin(), lineStr.begin() + 8);
    return [[NSString alloc] initWithCString:lineStr.c_str() encoding:NSUTF8StringEncoding];
}

+ (NSString *) getSnippetContent: (NSArray *) arrays{
    std::string snippet;
    for (NSString *line in arrays) {
        std::string lineStr([line cStringUsingEncoding:NSUTF8StringEncoding]);
        lineStr.erase(lineStr.begin());
        snippet += lineStr += "\n";
    }
    
    return [[NSString alloc] initWithCString:snippet.c_str() encoding:NSUTF8StringEncoding];
}
+ (BOOL) ifSnippet: (NSString *) line{
    if ([line rangeOfString:@"snippet"].location == 0) {
        return YES;
    } else return NO;
}
+ (BOOL) ifComment: (NSString *) line{
    if ([line rangeOfString:@"#"].location == 0) {
        return YES;
    } else return NO;
}
//new
+ (BOOL) ifEmpty: (NSString *) line{
    std::string lineStr([line cStringUsingEncoding:NSUTF8StringEncoding]);
    for (int i = 0; i < lineStr.length(); i ++) {
        if (lineStr[i] != ' ' || lineStr[i] != '\t' ) {
            return false;
        }
    }
    return true;
}
//new
@end
