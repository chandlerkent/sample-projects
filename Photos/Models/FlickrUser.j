@import <Foundation/CPObject.j>

@implementation FlickrUser : CPObject
{
    CPString    ID          @accessors(readonly);
    CPString    name        @accessors(readonly);
}

+ (id)flickrUserFromJSON:(JSON)json
{
    return [[[self class] alloc] initWithName:json.username._content ID:json.nsid]
}

- (id)initWithName:(CPString)aName ID:(CPString)anID
{
    if(self = [super init])
    {
        name = aName;
        ID = anID;
    }
    return self;
}

@end
