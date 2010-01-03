@import <Foundation/CPObject.j>

@import "../Views/PhotosView.j"

@implementation UserPhotosViewController : CPObject
{
    CPArray photos  @accessors;
    CPView  view    @accessors(readonly);
}

- (id)init
{
    if (self = [super init])
    {
        photos = [CPArray array];
    }
    return self;
}

- (CPView)setupViewWithFrame:(CGRect)aFrame
{
    if (view)
        return view;
    
    view = [[PhotosView alloc] initWithFrame:aFrame];
    [self addObserver:view forKeyPath:@"photos" options:CPKeyValueObservingOptionNew context:nil];
    return view;
}

@end

@implementation UserPhotosViewController (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    var allPhotos = [CPArray array];
    
    var albums = [object albums];
    
    for (var i = 0; i < [albums count]; i++)
    {
        [allPhotos addObjectsFromArray:[[albums objectAtIndex:i] photos]];
    }
    
    [self willChangeValueForKey:@"photos"];
    photos = [CPArray arrayWithArray:allPhotos];
    [self didChangeValueForKey:@"photos"];
}

@end