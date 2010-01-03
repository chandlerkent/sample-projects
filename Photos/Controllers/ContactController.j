@import <Foundation/CPObject.j>

@import "../Models/FlickrContact.j"
@import "../Views/ContactsView.j"

@implementation ContactController : CPObject
{
    CPArray         contacts            @accessors;
    CPDictionary    transientContacts   @accessors;
    CPView          view                @accessors(readonly);
}

- (id)init
{
    if(self = [super init])
    {
        contacts = [CPArray array];
        transientContacts = [CPDictionary dictionary];
        
        [[CPNotificationCenter defaultCenter] 
            addObserver:self
            selector:@selector(didReceiveContacts:)
            name:FlickrControllerDidGetContactsForUser
            object:nil];
            
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(didReceivePhotosForUser:)
            name:FlickrControllerDidGetPhotosForUser
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
    
    view = [[ContactsView alloc] initWithFrame:aFrame];
    [self addObserver:view forKeyPath:@"contacts" options:CPKeyValueObservingOptionNew context:nil];
    return view;
}

- (void)insertObject:(FlickrContact)contact inContactsAtIndex:(int)index
{
    [contacts insertObject:contact atIndex:index];
}

- (void)addContact:(FlickrContact)contact
{
    [self insertObject:contact inContactsAtIndex:[contacts count]];
}

@end

@implementation ContactController (FlickrControllerNotifications)

- (void)didReceiveContacts:(CPNotification)notification
{
    var userInfo = [notification userInfo];

    var user_id = [userInfo objectForKey:@"user_id"];
    var flickrContacts = [userInfo objectForKey:@"contacts"];

    for (var i = 0; i < [flickrContacts count]; i++)
    {
        var flickrContact = [flickrContacts objectAtIndex:i];
        
        [transientContacts setObject:flickrContact forKey:flickrContact.nsid];
        [[FlickrController sharedFlickrController] getPhotosForUser:flickrContact.nsid];
    }
}

- (void)didReceivePhotosForUser:(CPNotification)notification
{
    var userInfo = [notification userInfo];

    var contact_id = [userInfo objectForKey:@"user_id"];
    var flickrPhotos = [userInfo objectForKey:@"photos"];

    var photos = [CPArray array];
    for (var i = 0; i < [flickrPhotos count]; i++)
    {
        var flickrPhoto = [flickrPhotos objectAtIndex:i];
        var photo = [FlickrPhoto flickrPhotoFromJSON:flickrPhoto];

        [photos addObject:photo];
    }

    var flickrContact = [transientContacts objectForKey:contact_id];

    var contact = [FlickrContact flickrContactFromJSON:flickrContact];
    [contact setPhotos:photos];
    [self addContact:contact];

    [transientContacts removeObjectForKey:contact_id];
}

@end

@implementation ContactController (UserManagerCurrentUserDidChangeNotification)

- (void)userDidChange:(CPNotification)notification
{    
    var user = [[UserManager sharedUserManager] currentUser];
    
    [[FlickrController sharedFlickrController] getContactsForUser:[user ID]];
}

@end
