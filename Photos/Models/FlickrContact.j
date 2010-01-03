@import "FlickrUser.j"

@implementation FlickrContact : FlickrUser
{
    CPArray photos  @accessors;
}

+ (id)flickrContactFromJSON:(JSON)json
{
    return [[[self class] alloc] initWithName:json.username ID:json.nsid]
}

- (id)initWithName:(CPString)aName ID:(CPString)anID
{
    if(self = [super initWithName:aName ID:anID])
    {
        photos = [CPArray array];
    }
    return self;
}

@end
