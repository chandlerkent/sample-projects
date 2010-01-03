@import <AppKit/CPView.j>

@import "PhotosCollectionView.j"

@implementation FavoritesView : CPView
{
    PhotosCollectionView  photosView;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if(self = [super initWithFrame:aFrame])
    {
        [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        photosView = [[PhotosCollectionView alloc] initWithFrame:aFrame];
        [self addSubview:photosView];
    }
    return self;
}

@end

@implementation FavoritesView (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    [photosView updateContent:[object favorites]];
}

@end
