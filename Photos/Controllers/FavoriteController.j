@import <Foundation/CPObject.j>

@import "../Models/FlickrPhoto.j"
@import "../Views/FavoritesView.j"

@implementation FavoriteController : CPObject
{
    CPArray     favorites   @accessors;
    CPView      view        @accessors;
}

- (id)init
{
    if(self = [super init])
    {
        favorites = [CPArray array];
        
        [[CPNotificationCenter defaultCenter] 
            addObserver:self
            selector:@selector(didReceiveFavorites:)
            name:FlickrControllerDidGetFavoritesForUser
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
    
    view = [[FavoritesView alloc] initWithFrame:aFrame];
    [self addObserver:view forKeyPath:@"favorites" options:CPKeyValueObservingOptionNew context:nil];
    return view;
}

- (void)insertObject:(FlickrPhoto)favorite inFavoritesAtIndex:(int)index
{
    [favorites insertObject:favorite atIndex:index];
}

- (void)addFavorite:(FlickrPhoto)favorite
{
    [self insertObject:favorite inFavoritesAtIndex:[favorites count]];
}

@end

@implementation FavoriteController (FlickrControllerNotifications)

- (void)didReceiveFavorites:(CPNotification)notification
{
    var userInfo = [notification userInfo];

    var flickrFavorites = [userInfo objectForKey:@"favorites"];

    for (var i = 0; i < [flickrFavorites count]; i++)
    {
        var flickrFavorite = [flickrFavorites objectAtIndex:i];

        [self addFavorite:[FlickrPhoto flickrPhotoFromJSON:flickrFavorite]];
    }
}

@end

@implementation FavoriteController (UserManagerCurrentUserDidChangeNotification)

- (void)userDidChange:(CPNotification)notification
{    
    var user = [[UserManager sharedUserManager] currentUser];
    
    [[FlickrController sharedFlickrController] getFavoritesForUser:[user ID]];
}

@end
