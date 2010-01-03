/*
 * AppController.j
 * Photos
 *
 * Created by Chandler Kent on December 30, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "Controllers/FlickrController.j"
@import "Controllers/UserManager.j"

@import "Controllers/ContentViewController.j"
@import "Controllers/SidebarController.j"
@import "Controllers/AlbumController.j"
@import "Controllers/ContactController.j"
@import "Controllers/GroupController.j"
@import "Controllers/FavoriteController.j"
@import "Controllers/UserPhotosViewController.j"

@import "Models/FlickrUser.j"

@implementation AppController : CPObject
{
    @outlet CPWindow                theWindow; //this "outlet" is connected automatically by the Cib
    @outlet CPSplitView             splitView;
    @outlet CPScrollView            sidebarScrollView;
    @outlet CPButtonBar             buttonBar;
    @outlet SidebarController       sidebarController;
    @outlet ContentViewController   contentViewController;
    
    AlbumController             albumController;
    ContactController           contactController;
    GroupController             groupController;
    FavoriteController          favoriteController;
    UserPhotosViewController    userPhotosViewController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    albumController = [[AlbumController alloc] init];
    contactController = [[ContactController alloc] init];
    groupController = [[GroupController alloc] init];
    favoriteController = [[FavoriteController alloc] init];
    userPhotosViewController = [[UserPhotosViewController alloc] init];
    
    [albumController addObserver:userPhotosViewController forKeyPath:@"albums" options:CPKeyValueObservingOptionNew context:nil];
    
    [contentViewController addViewController:albumController];
    [contentViewController addViewController:contactController];
    [contentViewController addViewController:groupController];
    [contentViewController addViewController:favoriteController];
    [contentViewController addViewController:userPhotosViewController];
    
    [[CPNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(didFindUserByUserName:)
        name:FlickrControllerDidGetUserByUsername
        object:nil];
    
    [[FlickrController sharedFlickrController] getUserByUsername:@"ckentster"];
}

- (void)awakeFromCib
{
    [splitView setIsPaneSplitter:YES];
    [sidebarScrollView setAutohidesScrollers:YES];
}

@end

@implementation AppController (CPSplitViewDelegate)

- (CGFloat)splitView:(CPSplitView)aSplitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(int)dividerIndex
{
    return (proposedMin < 100) ? 100 : proposedMin;
}

- (CGFloat)splitView:(CPSplitView)aSplitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(int)dividerIndex
{
    return (proposedMax > 300) ? 300 : proposedMax;
}

- (CGRect)splitView:(CPSplitView)aSplitView additionalEffectiveRectOfDividerAtIndex:(int)index
{
    if (aSplitView === splitView)
    {
        var buttonBarFrame = [buttonBar frame];
        
        var additionalWidth = 20.0;
        var additionalRect = CGRectMake(buttonBarFrame.origin.x + buttonBarFrame.size.width - additionalWidth,
                                        buttonBarFrame.origin.y,
                                        additionalWidth,
                                        buttonBarFrame.size.height);
        return additionalRect;
    }   
}

@end

@implementation AppController (FlickrControllerDidGetUserByUsernameNotification)

- (void)didFindUserByUserName:(CPNotification)notification
{
    var userInfo = [notification userInfo];
    
    var username = [userInfo objectForKey:@"username"];
    var user_id = [userInfo objectForKey:@"user_id"];
    
    var user = [[FlickrUser alloc] initWithName:username ID:user_id];
    
    [[UserManager sharedUserManager] setCurrentUser:user];
}

@end