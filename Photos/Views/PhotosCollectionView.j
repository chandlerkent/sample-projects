@import <AppKit/CPView.j>

@implementation PhotosCollectionView : CPView
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
        
        var photoItem = [[CPCollectionViewItem alloc] init];
        [photoItem setView:[[PhotoView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)]];

        collectionView = [[CPCollectionView alloc] initWithFrame:aFrame];
        [collectionView setAllowsMultipleSelection:YES];
        [collectionView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];

        [collectionView setItemPrototype:photoItem]; //set the item prototype

        [collectionView setMinItemSize:size];
        [collectionView setMaxItemSize:size];

        [scrollView setDocumentView:collectionView];      

        [self addSubview:scrollView];
    }
    return self;
}

- (void)updateContent:(CPArray)content
{
    [collectionView setContent:content];
    [collectionView reloadContent];
}

@end

@implementation PhotoView : CPView
{
    CPView          enclosingView;
    CPImageView     photoView;
    CPView          selectedView;
}

- (void)setRepresentedObject:(FlickrPhoto)photo
{
    if (!enclosingView)
    {
        enclosingView = [[CPView alloc] initWithFrame:CGRectInset([self bounds], 10.0, 10.0)];
        [self addSubview:enclosingView];
    }
    if (!photoView)
    {
        photoView = [[CPImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([enclosingView bounds]), CGRectGetHeight([enclosingView bounds]) - 50.0)];
        [photoView setImageScaling:CPScaleProportionally];
        
        [enclosingView addSubview:photoView];
    }  
    
    var image = [[CPImage alloc] initWithContentsOfFile:[photo url]];
    [image setDelegate:self];
    [photoView setImage:image];
}

- (void)setSelected:(BOOL)flag
{
    [selectedView setHidden:!flag];
}

- (void)imageDidLoad:(CPImage)image
{
    if (!selectedView)
    {
        [photoView layoutSubviews]; // This is a hack to make sure [photoView imageRect] is non-null
        
        if ([photoView imageRect])
        {
            selectedView = [[CPView alloc] initWithFrame:[photoView imageRect]];
            var frame = [selectedView frame];
            [selectedView setFrameOrigin:CPMakePoint(frame.origin.x + 5.0, frame.origin.y + 5.0)];
            [selectedView setFrameSize:CPMakeSize(CGRectGetWidth(frame) + 10.0, CGRectGetHeight(frame) + 10.0)];
            [selectedView setBackgroundColor:[CPColor colorWithHexString:@"F8C863"]];
        
            [self addSubview:selectedView positioned:CPWindowBelow relativeTo:photoView];
            [selectedView setHidden:YES];
        }
    }
}

@end
