@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@import "../Models/SidebarItem.j"
@import "../Views/SidebarItemView.j"

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
    [column setDataView:[[SidebarItemView alloc] initWithFrame:CGRectMakeZero()]];

    outlineView = [[CPOutlineView alloc] initWithFrame:[[sidebarScrollView contentView] bounds]];
    [outlineView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [outlineView setHeaderView:nil];
    [outlineView setCornerView:nil];
    [outlineView addTableColumn:column];
    [outlineView setOutlineTableColumn:column];

    [outlineView setDataSource:self];

    [sidebarScrollView setDocumentView:outlineView];
    
    var allItems = [items allKeys];
    for (var i = 0; i < [allItems count]; i++)
    {
        [outlineView expandItem:[allItems objectAtIndex:i]];
    }
}

- (CPDictionary)defaultSidebarItems
{
    var AlbumsItem = [[SidebarItem alloc] initWithTitle:@"Albums" icon:[CPURL URLWithString:[[CPBundle mainBundle] pathForResource:@"Images/albums.tiff"]]];
    var GroupsItem = [[SidebarItem alloc] initWithTitle:@"Groups" icon:[CPURL URLWithString:[[CPBundle mainBundle] pathForResource:@"Images/groups.tiff"]]];
    var ContactsItem = [[SidebarItem alloc] initWithTitle:@"Contacts" icon:[CPURL URLWithString:[[CPBundle mainBundle] pathForResource:@"Images/contacts.tiff"]]];
    var FavoritesItem = [[SidebarItem alloc] initWithTitle:@"Favorites" icon:[CPURL URLWithString:[[CPBundle mainBundle] pathForResource:@"Images/favorites.tiff"]]];
    var PhotosItem = [[SidebarItem alloc] initWithTitle:@"Photos" icon:[CPURL URLWithString:[[CPBundle mainBundle] pathForResource:@"Images/photos.tiff"]]];
    
    var LibraryItem = [[SidebarItem alloc] initWithTitle:@"Library" icon:nil];
    
    return [CPDictionary dictionaryWithObjectsAndKeys:[AlbumsItem, GroupsItem, ContactsItem, FavoritesItem, PhotosItem], LibraryItem];
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
    return item;
}

@end
