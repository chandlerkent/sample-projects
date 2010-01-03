@import <Foundation/CPObject.j>

// http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg

@implementation FlickrPhoto : CPObject
{
    CPURL       url         @accessors;
    CPString    title       @accessors;
}

+ (id)flickrPhotoFromJSON:(JSON)json
{
    return [[[self class] alloc] initWithTitle:json.title url:[self createPhotoURLFromJSON:json]];
}

+ (CPURL)createPhotoURLFromJSON:(JSON)json
{
    var string = "http://farm" + json.farm + ".static.flickr.com/" + json.server + "/" + json.id + "_" + json.secret + "_m.jpg";
    
    return [CPURL URLWithString:string];
}

- (id)initWithTitle:(CPString)aTitle url:(CPURL)aUrl
{
    if(self = [super init])
    {
        title = aTitle;
        url = aUrl;
    }
    return self;
}

@end
