@import <Foundation/CPObject.j>

@implementation ContentViewController : CPObject
{
    @outlet CPView  contentView;
}

- (void)awakeFromCib
{
    [[CPNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(outlineViewSelectionDidChange:)
        name:CPOutlineViewSelectionDidChangeNotification
        object:nil];
}

- (void)outlineViewSelectionDidChange:(CPNotification)notification
{
    var outlineView = [notification object];
    var selectedRow = [[outlineView selectedRowIndexes] firstIndex];
    var item = [outlineView itemAtRow:selectedRow];

    if ([item color])
    {
        [contentView setBackgroundColor:[item color]];
    }
    else
    {
        [contentView setBackgroundColor:[CPColor clearColor]];
    }
}

@end
