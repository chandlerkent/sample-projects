@import <Foundation/CPObject.j>

@implementation SidebarColorItem : CPObject
{
    CPString    name    @accessors;
    CPColor     color   @accessors;
}

- (id)init
{
    return [self initWithName:@"" color:nil];
}

- (id)initWithName:(CPString)aName color:(CPColor)aColor
{
    if (self = [super init])
    {
        name = aName;
        color = aColor;
    }
    return self;
}

@end
