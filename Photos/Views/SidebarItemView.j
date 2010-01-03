@import <AppKit/CPView.j>

@implementation SidebarItemView : CPView
{
    CPTextField     label;
    CPImageView     iconView;
}

- (void)setObjectValue:(SidebarItem)item
{
    if (!label)
    {
        var rect = [self bounds];
        if ([item iconURL])
        {
            rect = CGRectInset([self bounds], 21.0, 1.0);
        }
        label = [[CPTextField alloc] initWithFrame:rect];
        [label setFont:[CPFont boldSystemFontOfSize:12.0]];
        [label setTextShadowColor:[CPColor whiteColor]];
        [label setTextShadowOffset:CGSizeMake(0, 1)];
        [self addSubview:label];
    }
    if (!iconView && [item iconURL])
    {
        iconView = [[CPImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 18.0, 18.0)];
        [iconView setImageScaling:CPScaleProportionally];
        [self addSubview:iconView];
    }
    
    [label setStringValue:[item title]];
    [label sizeToFit];
    
    if ([item iconURL])
    {
        [iconView setImage:[[CPImage alloc] initWithContentsOfFile:[item iconURL]]];
    }
}

@end
