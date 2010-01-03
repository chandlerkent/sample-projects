@import <Foundation/CPObject.j>

@import "../Models/FlickrGroup.j"
@import "../Views/GroupsView.j"

@implementation GroupController : CPObject
{
    CPArray         groups              @accessors;
    CPDictionary    transientGroups     @accessors;
    CPView          view                @accessors;
}

- (id)init
{
    if(self = [super init])
    {
        groups = [CPArray array];
        transientGroups = [CPDictionary dictionary];
        
        [[CPNotificationCenter defaultCenter] 
            addObserver:self
            selector:@selector(didReceiveGroups:)
            name:FlickrControllerDidGetGroupsForUser
            object:nil];
        
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(didReceivePhotosForGroup:)
            name:FlickrControllerDidGetPhotosForGroup
            object:nil];
            
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(userDidChange:)
            name:UserManagerCurrentUserDidChangeNotification
            object:nil];
    }
    return self;
}

- (CPView)setupViewWithFrame:(CGRect)aFrame
{
    if (view)
        return view;
    
    view = [[GroupsView alloc] initWithFrame:aFrame];
    [self addObserver:view forKeyPath:@"groups" options:CPKeyValueObservingOptionNew context:nil];
    return view;
}

- (void)insertObject:(FlickrGroup)group inGroupsAtIndex:(int)index
{
    [groups insertObject:group atIndex:index];
}

- (void)addGroup:(FlickrGroup)group
{
    [self insertObject:group inGroupsAtIndex:[groups count]];
}

@end

@implementation GroupController (FlickrControllerNotifications)

- (void)didReceiveGroups:(CPNotification)notification
{
    var userInfo = [notification userInfo];

    var user_id = [userInfo objectForKey:@"user_id"];
    var flickrGroups = [userInfo objectForKey:@"groups"];

    for (var i = 0; i < [flickrGroups count]; i++)
    {
        var flickrGroup = [flickrGroups objectAtIndex:i];

        [transientGroups setObject:flickrGroup forKey:flickrGroup.nsid];
        [[FlickrController sharedFlickrController] getPhotosForGroup:flickrGroup.nsid];
    }
}

- (void)didReceivePhotosForGroup:(CPNotification)notification
{
    var userInfo = [notification userInfo];
    
    var group_id = [userInfo objectForKey:@"group_id"];
    var flickrPhotos = [userInfo objectForKey:@"photos"];
    
    var photos = [CPArray array];
    for (var i = 0; i < [flickrPhotos count]; i++)
    {
        var flickrPhoto = [flickrPhotos objectAtIndex:i];
        var photo = [FlickrPhoto flickrPhotoFromJSON:flickrPhoto];
        
        [photos addObject:photo];
    }
    
    var flickrGroup = [transientGroups objectForKey:group_id];
    
    var group = [FlickrGroup flickrGroupFromJSON:flickrGroup];
    [group setPhotos:photos];
    [self addGroup:group];
    
    [transientGroups removeObjectForKey:group_id];
}

@end

@implementation GroupController (UserManagerCurrentUserDidChangeNotification)

- (void)userDidChange:(CPNotification)notification
{    
    var user = [[UserManager sharedUserManager] currentUser];
    
    [[FlickrController sharedFlickrController] getGroupsForUser:[user ID]];
}

@end
