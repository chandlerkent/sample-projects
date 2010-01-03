@import <AppKit/CPControl.j>

@implementation ImageRolloverControl : CPControl
{
    CPArray     images;
    
    CPImage     activeImage     @accessors;
    CPImage     permanentImage  @accessors;
    BOOL        isActive        @accessors;
    
    CPImageView imageView;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if(self = [super initWithFrame:aFrame])
    {
        [self setBackgroundColor:[CPColor blackColor]];
        
        images = [CPArray array];
        isActive = NO;
        
        imageView = [[CPImageView alloc] initWithFrame:[self bounds]];
        [imageView setImageScaling:CPScaleNone];
        [self addSubview:imageView];
        
        [self addObserver:self forKeyPath:@"activeImage" options:CPKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"isActive" options:CPKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"permanentImage" options:CPKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)setPhotos:(CPArray)somePhotos
{
    images = [CPArray array];
    
    for (var i = 0; i < [somePhotos count]; i++)
    {
        var photo = [somePhotos objectAtIndex:i];
        var image = [[CPImage alloc] initWithContentsOfFile:[photo url]];
        [images addObject:image];
    }
    
    [self setPermanentImage:[[images objectAtIndex:0] copy]];
    [imageView setImage:[self permanentImage]];
}

- (void)viewWillMoveToWindow:(CPWindow)aWindow
{
    [aWindow setAcceptsMouseMovedEvents:YES];
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)mouseEntered:(CPEvent)anEvent  
{
    [self setIsActive:YES];
}  

- (void)mouseExited:(CPEvent)anEvent  
{
    [self setIsActive:NO];
}

- (void)keyDown:(CPEvent)anEvent
{
    var keyCode = [anEvent keyCode];
    
    switch (keyCode)
    {
        case 32: // space
            [self setPermanentImage:[self activeImage]];
            break;
        default:
            return [super keyDown:anEvent];
    }
}

- (void)mouseDown:(CPEvent)anEvent
{
    // forward to superview
    [[self superview] mouseDown:anEvent];
}

- (void)mouseMoved:(CPEvent)anEvent  
{    
    var width = [self bounds].size.width;
    var stepWidth = width / [images count];
    var offset = [self convertPoint:[anEvent locationInWindow] fromView:nil].x;
    var imageIndex = FLOOR(offset/stepWidth);
    var clampedIndex = MIN(MAX(imageIndex, 0), [images count] - 1);
    
    [self setActiveImage:[images objectAtIndex:clampedIndex]];
}

@end

@implementation ImageRolloverControl (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"isActive":
            if (![self isActive])
            {
                [imageView setImageScaling:CPScaleNone];
                [imageView setImage:[object permanentImage]];
                [[self window] makeFirstResponder:[self window]];
            }
            else
            {
                [imageView setImageScaling:CPScaleProportionally];
                [[self window] makeFirstResponder:self];
            }
            break;
        case @"activeImage":
            [imageView setImage:[object activeImage]];
            break;
        case @"permanentImage":
            var size = [permanentImage size];
            var viewSize = [self bounds].size;
            
            var scale = 1;
            if (size.width < viewSize.width)
            {
                scale = viewSize.width / size.width;
            }
            else if (size.height < viewSize.height)
            {
                scale = viewSize.height / size.height;
            }
            
            size.width *= scale;
            size.height *= scale;
            [permanentImage setSize:size];
            break;
        default:
            break;
    }
}

@end
