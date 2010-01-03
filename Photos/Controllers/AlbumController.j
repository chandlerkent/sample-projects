@import <Foundation/CPObject.j>

@import "../Models/FlickrAlbum.j"
@import "../Views/AlbumsView.j"

@implementation AlbumController : CPObject
{
    CPArray         albums          @accessors;
    CPDictionary    transientAlbums;
    CPView          view            @accessors(readonly);
}

- (id)init
{
    if (self = [super init])
    {
        [[CPNotificationCenter defaultCenter] 
            addObserver:self
            selector:@selector(didReceiveAlbums:)
            name:FlickrControllerDidGetPhotosetsForUser
            object:nil];
            
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(didReceivePhotosForAlbum:)
            name:FlickrControllerDidGetPhotosForPhotoset
            object:nil];
            
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(userDidChange:)
            name:UserManagerCurrentUserDidChangeNotification
            object:nil];

        albums = [CPArray array];
        transientAlbums = [CPDictionary dictionary];
    }
    return self;
}

- (CPView)setupViewWithFrame:(CGRect)aFrame
{
    if (view)
        return view;
    
    view = [[AlbumsView alloc] initWithFrame:aFrame];
    [self addObserver:view forKeyPath:@"albums" options:CPKeyValueObservingOptionNew context:nil];
    return view;
}

- (void)addAlbum:(FlickrAlbum)album
{
    [self insertObject:album inAlbumsAtIndex:[albums count]];
}

- (void)insertObject:(FlickrAlbum)album inAlbumsAtIndex:(int)index
{
    [albums insertObject:album atIndex:index];
}

@end

@implementation AlbumController (FlickrControllerNotifications)

- (void)didReceiveAlbums:(CPNotification)notification
{
    var userInfo = [notification userInfo];

    var user_id = [userInfo objectForKey:@"user_id"];
    var flickrAlbums = [userInfo objectForKey:@"albums"];

    for (var i = 0; i < [flickrAlbums count]; i++)
    {
        var flickrAlbum = [flickrAlbums objectAtIndex:i];

        [transientAlbums setObject:flickrAlbum forKey:flickrAlbum.id];
        [[FlickrController sharedFlickrController] getPhotosForPhotoset:flickrAlbum.id];
    }
}

- (void)didReceivePhotosForAlbum:(CPNotification)notification
{
    var userInfo = [notification userInfo];
    
    var album_id = [userInfo objectForKey:@"photoset_id"];
    var flickrPhotos = [userInfo objectForKey:@"photos"];
    
    var photos = [CPArray array];
    for (var i = 0; i < [flickrPhotos count]; i++)
    {
        var flickrPhoto = [flickrPhotos objectAtIndex:i];
        var photo = [FlickrPhoto flickrPhotoFromJSON:flickrPhoto];
        
        [photos addObject:photo];
    }
    
    var flickrAlbum = [transientAlbums objectForKey:album_id];
    
    var album = [FlickrAlbum flickrAlbumFromJSON:flickrAlbum];
    [album setPhotos:photos]
    [self addAlbum:album];
    
    [transientAlbums removeObjectForKey:album_id];
}


@end

@implementation AlbumController (UserManagerCurrentUserDidChangeNotification)

- (void)userDidChange:(CPNotification)notification
{    
    var user = [[UserManager sharedUserManager] currentUser];
    
    [[FlickrController sharedFlickrController] getPhotosetsForUser:[user ID]];
}

@end