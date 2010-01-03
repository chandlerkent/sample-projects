@import <Foundation/CPObject.j>

@implementation SidebarItem : CPObject
{
    CPString    title   @accessors(readonly);
    CPURL       iconURL @accessors(readonly);
}

- (id)init
{
    return [self initWithTitle:@"Default" icon:nil];
}

- (id)initWithTitle:(CPString)aTitle icon:(CPURL)anURL
{
    if(self = [super init])
    {
        title = aTitle;
        iconURL = anURL;
    }
    return self;
}

@end
