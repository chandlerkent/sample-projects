/*
 * AppController.j
 * SidebarChangingContentView
 *
 * Created by Chandler Kent on January 8, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "SidebarController.j"
@import "ContentViewController.j"

@implementation AppController : CPObject
{
    @outlet CPWindow            theWindow; //this "outlet" is connected automatically by the Cib
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    // This is called when the application is done loading.
}

- (void)awakeFromCib
{
}

@end
