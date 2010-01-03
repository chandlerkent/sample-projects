@import <Foundation/CPObject.j>

@implementation FlickrGroup : CPObject
{
    CPString    ID      @accessors;
    CPString    name    @accessors;
    CPArray     photos  @accessors;
}

+ (id)flickrGroupFromJSON:(JSON)json
{
    return [[[self class] alloc] initWithName:json.name ID:json.nsid];
}

- (id)initWithName:(CPString)aName ID:(CPString)anID
{
    if(self = [super init])
    {
        name = aName;
        ID = anID;
        photos = [CPArray array];
    }
    return self;
}

@end
