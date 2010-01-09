@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@import "SidebarColorItem.j"

@implementation SidebarController : CPObject
{
    @outlet CPScrollView    sidebarScrollView;

    CPOutlineView   outlineView;
    CPDictionary    items;
}

- (void)awakeFromCib
{
    items = [self defaultSidebarItems];

    var column = [[CPTableColumn alloc] initWithIdentifier:@"column"];
    [column setWidth:400.0];

    outlineView = [[CPOutlineView alloc] initWithFrame:[[sidebarScrollView contentView] bounds]];
    [outlineView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [outlineView setHeaderView:nil];
    [outlineView setCornerView:nil];
    [outlineView addTableColumn:column];
    [outlineView setOutlineTableColumn:column];

    [outlineView setDataSource:self];

    [sidebarScrollView setDocumentView:outlineView];

    [self expandAllItems];
}

- (void)expandAllItems
{
    var allItems = [items allKeys];
    for (var i = 0; i < [allItems count]; i++)
    {
        [outlineView expandItem:[allItems objectAtIndex:i]];
    }
}

- (CPDictionary)defaultSidebarItems
{
    var redColor = [[SidebarColorItem alloc] initWithName:@"Red" color:[CPColor redColor]];
    var blueColor = [[SidebarColorItem alloc] initWithName:@"Blue" color:[CPColor blueColor]];
    var greenColor = [[SidebarColorItem alloc] initWithName:@"Green" color:[CPColor greenColor]];
    
    var colorItem = [[SidebarColorItem alloc] initWithName:@"Colors" color:nil];
    
    return [CPDictionary dictionaryWithObjectsAndKeys:[redColor, greenColor, blueColor], colorItem];
}

@end

@implementation SidebarController (CPOutlineViewDataSource)

- (id)outlineView:(CPOutlineView)outlineView child:(int)child ofItem:(id)item
{
    if (item === nil)
    {
        var keys = [items allKeys];
        return [keys objectAtIndex:child];
    }
    else
    {
        var values = [items objectForKey:item];
        return [values objectAtIndex:child];
    }
}

- (BOOL)outlineView:(CPOutlineView)outlineView isItemExpandable:(id)item
{
    var values = [items objectForKey:item];
    return ([values count] > 0);
}

- (int)outlineView:(CPOutlineView)outlineView numberOfChildrenOfItem:(id)item
{
    if (item === nil)
    {
        return [items count];
    }
    else
    {
        var values = [items objectForKey:item];
        return [values count];
    }
}

- (id)outlineView:(CPOutlineView)outlineView objectValueForTableColumn:(CPTableColumn)tableColumn byItem:(id)item
{
    return [item name];
}

@end

