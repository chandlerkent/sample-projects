@import <Foundation/CPObject.j>

@import "../Views/PhotosView.j"


@implementation ContentViewController : CPObject
{
    @outlet     CPView      contentView;

    CPDictionary    views;
    CPView          currentView;
}

- (void)awakeFromCib
{
    [[CPNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(outlineViewSelectionDidChange:)
        name:CPOutlineViewSelectionDidChangeNotification
        object:nil];
    
    views = [CPDictionary dictionary];
}

- (void)addViewController:(id)viewController
{
    var view = [viewController setupViewWithFrame:[contentView bounds]];
    [contentView addSubview:view];
    [view setHidden:YES];
    
    [views setObject:view forKey:[view className]];
}

@end

@implementation ContentViewController (CPOutlineViewNotifications)

- (void)outlineViewSelectionDidChange:(CPNotification)notification
{
    var outlineView = [notification object];
    var selectedRow = [[outlineView selectedRowIndexes] firstIndex];
    var item = [outlineView itemAtRow:selectedRow];
    
    var viewName = [item title] + "View";
    var view = [views objectForKey:viewName];

    [currentView setHidden:YES];
    
    if (view)
    {
        [view setHidden:NO];
        currentView = view;
    }
}

@end
