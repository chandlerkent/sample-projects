@import <AppKit/CPView.j>

@import "ImageRolloverControl.j"

@implementation PhotoGroupView : CPView
{
    CPView              highlightView;
    CPTextField         titleTextField;
    CPTextField         captionTextField;
    
    ImageRolloverControl imageRollover;
}

- (void)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {        
        var imageRolloverFrame = CGRectInset([self bounds], 5.0, 5.0);
        imageRolloverFrame.size.height -= 50.0;
        imageRollover = [[ImageRolloverControl alloc] initWithFrame:imageRolloverFrame];
        [self addSubview:imageRollover];
            
        var highlightViewFrame = [self bounds];
        highlightViewFrame.size.height -= 50.0;
        highlightView = [[CPView alloc] initWithFrame:highlightViewFrame];
        [highlightView setBackgroundColor:[CPColor colorWithHexString:@"F8C863"]];
        [highlightView setHidden:YES];
        [self addSubview:highlightView positioned:CPWindowBelow relativeTo:imageRollover];
    }
    return self;
}

- (void)setPhotos:(CPArray)photos
{
    [imageRollover setPhotos:photos];
}

- (void)highlight:(BOOL)flag
{
    [highlightView setHidden:!flag];
    [captionTextField setHidden:!flag];
}

- (void)setCaption:(CPString)caption
{
    if (!captionTextField)
    {
        [self setupCaptionTextField];
    }
    
    [captionTextField setStringValue:caption];
    [captionTextField sizeToFit];
    [self repositionCaptionTextField];
}

- (void)setupCaptionTextField
{
    captionTextField = [[CPTextField alloc] initWithFrame:CGRectInset([self bounds], 10.0, 10.0)];
    [captionTextField setFont:[CPFont systemFontOfSize:10.0]];
    [captionTextField setTextColor:[CPColor grayColor]];
    
    [captionTextField setTextShadowColor:[CPColor grayColor]];
    [captionTextField setTextShadowOffset:CGSizeMake(0, 1)];
    
    [captionTextField setAlignment:CPCenterTextAlignment];
    [captionTextField setLineBreakMode:CPLineBreakByWordWrapping];
    
    [captionTextField setHidden:YES];
    
    [self addSubview:captionTextField];
}

- (void)repositionCaptionTextField
{
    [captionTextField setFrameSize:CGSizeMake(CGRectGetWidth([self bounds]), 30.0)];
    var titleTextFieldFrame = [titleTextField frame];
    var yPosition = titleTextFieldFrame.size.height + titleTextFieldFrame.origin.y + (CGRectGetHeight([captionTextField bounds]) / 2.0) - 3.0;
    [captionTextField setCenter:CPMakePoint(CGRectGetWidth([self bounds]) / 2.0, yPosition)];
}

- (void)setTitle:(CPString)title
{
    if (!titleTextField)
    {
        [self setupTitleTextField];
    }
    [titleTextField setStringValue:title];
    [titleTextField sizeToFit];
    [self repositionTitleTextField];
}

- (void)setupTitleTextField
{
    titleTextField = [[CPTextField alloc] initWithFrame:CGRectInset([self bounds], 10.0, 10.0)];
    
    [titleTextField setFont:[CPFont boldFontWithName:@"Lucida Grande" size:12.0]];
    [titleTextField setTextColor:[CPColor whiteColor]];
    
    [titleTextField setTextShadowColor:[CPColor blackColor]];
    [titleTextField setTextShadowOffset:CGSizeMake(0, 1)];
    
    [titleTextField setAlignment:CPCenterTextAlignment];
    [titleTextField setLineBreakMode:CPLineBreakByTruncatingTail];
    
    [self addSubview:titleTextField];
}

- (void)repositionTitleTextField
{
    if (CGRectGetWidth([titleTextField bounds]) > CGRectGetWidth([self bounds]))
    {
        var oldFrame = [titleTextField frame];
        [titleTextField setFrameSize:CGSizeMake(CGRectGetWidth([self bounds]), oldFrame.size.height)];
    }
    [titleTextField setCenter:CPMakePoint(CGRectGetWidth([self bounds]) / 2.0, CGRectGetHeight([highlightView bounds]) + (CGRectGetHeight([titleTextField bounds]) / 2.0))];
}

@end