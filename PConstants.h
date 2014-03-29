//
//  PConstants.h
//  PluginController
//
//  Created by Jingkui Wang on 12/28/13.
//  Copyright (c) 2013 Jingkui Wang. All rights reserved.
//

#ifndef PluginController_PConstants_h
#define PluginController_PConstants_h

#import <Foundation/Foundation.h>

NSString *vimPathEnd = @"/.vim";
NSString *cfgPathEnd = @"/.vim/PCfig.plist";
NSString *pathogenPathEnd = @"/.vim/autoload/pathogen.vim";
NSString *vimrcPathEnd = @"/.vimrc";
NSString *autoldPathEnd = @"/.vim/autoload";

NSString *bundlePathEnd = @"/.vim/Bundle/";

NSString *git = @"/usr/bin/git";
NSString *gitArgu = @"clone";

NSString *rm = @"/bin/rm";
NSString *rmArgu = @"-rf";

NSString *initVimrc = @"call pathogen#infect()\n :filetype plugin on\n";

NSString *snippetFilesEnd = @"/.vim/bundle/snipMate/snippets";
NSString *filetypeVim = @"";
#endif
