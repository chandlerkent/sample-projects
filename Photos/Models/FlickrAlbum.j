@import <Foundation/CPObject.j>

@implementation FlickrAlbum : CPObject
{
    CPString    albumID     @accessors(readonly);
    CPString    title       @accessors(readonly);
    CPString    description @accessors(readonly);
    CPArray     photos      @accessors;
}

+ (id)flickrAlbumFromJSON:(JSON)json
{
    return [[[self class] alloc] initWithID:json.id title:json.title._content description:json.description._content];
}

- (id)initWithID:(CPString)anID title:(CPString)aTitle description:(CPString)aDescription
{
    if (self = [super init])
    {
        albumID = anID;
        title = aTitle;
        description = aDescription;
        photos = [CPArray array];
    }
    return self;
}

@end
