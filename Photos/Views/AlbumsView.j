@import <AppKit/CPView.j>

@implementation AlbumsView : CPView
{
    CPCollectionView collectionView;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if(self = [super initWithFrame:aFrame])
    {
        [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        var scrollView = [[CPScrollView alloc] initWithFrame:aFrame];
        [scrollView setAutohidesScrollers:YES];
        [scrollView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
        [[scrollView contentView] setBackgroundColor:[CPColor colorWithHexString:@"302f30"]];

        var size = CGSizeMake(250.0, 250.0);
        
        var albumItem = [[CPCollectionViewItem alloc] init];
        [albumItem setView:[[AlbumView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)]];

        collectionView = [[CPCollectionView alloc] initWithFrame:aFrame];
        [collectionView setAllowsMultipleSelection:YES];
        [collectionView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];

        [collectionView setDelegate:self]; //we want delegate methods
        [collectionView setItemPrototype:albumItem]; //set the item prototype

        [collectionView setMinItemSize:size];
        [collectionView setMaxItemSize:size];

        [scrollView setDocumentView:collectionView];      

        [self addSubview:scrollView];
    }
    return self;
}

@end

@implementation AlbumsView (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    [collectionView setContent:[object albums]];
    [collectionView reloadContent];
}

@end

@import "PhotoGroupView.j"

@implementation AlbumView : CPView
{
    PhotoGroupView  photoGroupView;
}

- (void)setRepresentedObject:(FlickrAlbum)album
{
    if (!photoGroupView)
    {
        photoGroupView = [[PhotoGroupView alloc] initWithFrame:CGRectInset([self bounds], 20.0, 20.0)];
        [self addSubview:photoGroupView];
    }
    
    [photoGroupView setTitle:[album title]];
    [photoGroupView setCaption:[album description]];
    [photoGroupView setPhotos:[album photos]];
}

- (void)setSelected:(BOOL)flag
{
    [photoGroupView highlight:flag];
}

@end
