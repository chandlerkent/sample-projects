@import <AppKit/CPView.j>

@implementation ContactsView : CPView
{
    CPCollectionView collectionView;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if(self = [super initWithFrame:aFrame])
    {
        [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        var corkImage = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/cork-bg.png"]];
        [self setBackgroundColor:[CPColor colorWithPatternImage:corkImage]];
        
        var scrollView = [[CPScrollView alloc] initWithFrame:aFrame];
        [scrollView setAutohidesScrollers:YES];
        [scrollView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];

        var size = CGSizeMake(280.0, 250.0);
        
        var contactItem = [[CPCollectionViewItem alloc] init];
        [contactItem setView:[[ContactView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)]];

        collectionView = [[CPCollectionView alloc] initWithFrame:aFrame];
        [collectionView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
        
        [collectionView setItemPrototype:contactItem];

        [collectionView setMinItemSize:size];
        [collectionView setMaxItemSize:size];

        [scrollView setDocumentView:collectionView];      

        [self addSubview:scrollView];
    }
    return self;
}

@end

@implementation ContactsView (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    [collectionView setContent:[object contacts]];
    [collectionView reloadContent];
}

@end

@import "ImageRolloverControl.j"

@implementation ContactView : CPView
{
    CPTextField         name;
    ImageRolloverControl face;
    
    CPView              selectedView;
    CPView              polaroidView;
}

- (void)setRepresentedObject:(FlickrContact)contact
{
    if (!polaroidView)
    {
        polaroidView = [[CPView alloc] initWithFrame:CGRectInset([self bounds], 20.0, 20.0)];
        [polaroidView setBackgroundColor:[CPColor colorWithHexString:@"DEDEE8"]];
        
        [self addSubview:polaroidView];
    }
    if (!face)
    {
        var padding = 10.0;
        face = [[ImageRolloverControl alloc] initWithFrame:CGRectMake(padding, padding, CGRectGetWidth([polaroidView bounds]) - (padding * 2), CGRectGetHeight([polaroidView bounds]) - padding - 40.0)];
        
        [polaroidView addSubview:face];
    }
    if (!name)
    {
        name = [[CPTextField alloc] initWithFrame:CGRectInset([polaroidView bounds], 10.0)];
        [name setFont:[CPFont boldFontWithName:@"Comic Sans" size:20.0]];
        [name setTextShadowColor:[CPColor whiteColor]];
        [name setTextShadowOffset:CGSizeMake(0, 1)];
        [name setAlignment:CPCenterTextAlignment];
        
        [polaroidView addSubview:name];
    }
    if (!selectedView)
    {
        selectedView = [[CPView alloc] initWithFrame:CGRectInset([self bounds], 13.0, 13.0)];
        [selectedView setBackgroundColor:[[CPColor colorWithHexString:@"5D8CC4"] colorWithAlphaComponent:0.8]];
        
        [self addSubview:selectedView positioned:CPWindowBelow relativeTo:polaroidView];
        [selectedView setHidden:YES];
    }
    
    [face setPhotos:[contact photos]];
    
    [name setStringValue:[contact name]];
    [name sizeToFit];
    [name setCenter:CPMakePoint(CGRectGetWidth([polaroidView bounds]) / 2.0, CGRectGetHeight([face bounds]) + 30.0)];
}

- (void)setSelected:(BOOL)flag
{
    [selectedView setHidden:!flag];
}

@end
