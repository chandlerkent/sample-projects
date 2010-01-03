@import <Foundation/CPObject.j>

@import "../Models/FlickrUser.j"


UserManagerCurrentUserDidChangeNotification = @"UserManagerCurrentUserDidChangeNotification";

var SharedUserManager = nil

@implementation UserManager : CPObject
{
    FlickrUser  currentUser     @accessors(readonly);
}

+ (id)sharedUserManager
{
    if (!SharedUserManager)
    {
        SharedUserManager = [[UserManager alloc] init];
    }
    
    return SharedUserManager;
}

- (void)setCurrentUser:(FlickrUser)user
{
    if (user !== currentUser)
    {
        currentUser = user;
        [[CPNotificationCenter defaultCenter]
            postNotificationName:UserManagerCurrentUserDidChangeNotification
            object:self];
    }
}

@end
