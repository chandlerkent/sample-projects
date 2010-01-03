@import <AppKit/CPView.j>

@implementation GroupsView : CPView
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
        
        var groupItem = [[CPCollectionViewItem alloc] init];
        [groupItem setView:[[GroupView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)]];

        collectionView = [[CPCollectionView alloc] initWithFrame:aFrame];
        [collectionView setAllowsMultipleSelection:YES];
        [collectionView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];

        [collectionView setItemPrototype:groupItem]; //set the item prototype

        [collectionView setMinItemSize:size];
        [collectionView setMaxItemSize:size];

        [scrollView setDocumentView:collectionView];      

        [self addSubview:scrollView];
    }
    return self;
}

@end

@implementation GroupsView (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    [collectionView setContent:[object groups]];
    [collectionView reloadContent];
}

@end

@import "PhotoGroupView.j"

@implementation GroupView : CPView
{
    PhotoGroupView  photoGroupView;
}

- (void)setRepresentedObject:(FlickrGroup)group
{
    if (!photoGroupView)
    {
        photoGroupView = [[PhotoGroupView alloc] initWithFrame:CGRectInset([self bounds], 20.0, 20.0)];
        [self addSubview:photoGroupView];
    }
    
    [photoGroupView setPhotos:[group photos]];
    [photoGroupView setTitle:[group name]];
}

- (void)setSelected:(BOOL)flag
{
    [photoGroupView highlight:flag];
}

@end
