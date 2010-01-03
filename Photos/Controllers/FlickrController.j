@import <Foundation/CPObject.j>

FlickrControllerDidGetPhotosetsForUser = @"FlickrControllerDidGetPhotosetsForUser";
FlickrControllerDidGetUserByUsername = @"FlickrControllerDidGetUserByUsername";
FlickrControllerDidGetContactsForUser = @"FlickrControllerDidGetContactsForUser";
FlickrControllerDidGetGroupsForUser = @"FlickrControllerDidGetGroupsForUser";
FlickrControllerDidGetFavoritesForUser = @"FlickrControllerDidGetFavoritesForUser";
FlickrControllerDidGetPhotosForPhotoset = @"FlickrControllerDidGetPhotosForPhotoset";
FlickrControllerDidGetPhotosForGroup = @"FlickrControllerDidGetPhotosForGroup";
FlickrControllerDidGetPhotosForUser = @"FlickrControllerDidGetPhotosForUser";


var SharedFlickrController = nil;
var APIKey = @"0f5c6376f5d27be5ce4486221531c5a7";

@implementation FlickrController : CPObject
{
    CPString        apiKey;
    CPURL           flickrURL;
    CPDictionary    connections;
    
    id              delegate        @accessors;
}

+ (id)sharedFlickrController
{
    if (!SharedFlickrController)
    {
        SharedFlickrController = [[FlickrController alloc] initWithAPIKey:APIKey];
    }
    
    return SharedFlickrController;
}

- (id)initWithAPIKey:(CPString)anAPIKey
{
    if (self = [super init])
    {
        apiKey = anAPIKey; 
        flickrURL = [CPURL URLWithString:@"http://api.flickr.com/services/rest/"]; 
        connections = [CPDictionary dictionary]; 
    }
    return self;
}

- (CPURL)createURLWithQueryOptions:(CPDictionary)options
{
    [options setObject:@"json" forKey:@"format"];
    [options setObject:apiKey forKey:@"api_key"];

    var queryString = @"?";
    
    var keys = [options allKeys];
    for (var i = 0; i < [keys count]; i++)
    {
        var key = [keys objectAtIndex:i];
        queryString += key + @"=" + [options objectForKey:key];
        
        if (i < ([keys count] - 1))
        {
            queryString += @"&";
        }
    }
    
    // console.log(_cmd, queryString);
    
    return [CPURL URLWithString:[flickrURL absoluteString] + queryString];    
}

- (void)createAndStartConnectionWithOptions:(CPDictionary)options
{
    var url = [self createURLWithQueryOptions:options];

    var request = [CPURLRequest requestWithURL:url];
    var connection = [CPJSONPConnection connectionWithRequest:request callback:@"jsoncallback" delegate:self];

    [connections setObject:options forKey:connection];
}

- (void)getPhotosetsForUser:(CPString)user_id
{
    var method = @"flickr.photosets.getList";

    var connectionOptions = [CPDictionary dictionaryWithObjects:[method, user_id] forKeys:[@"method", @"user_id"]];

    [self createAndStartConnectionWithOptions:connectionOptions];
}

- (void)getUserByUsername:(CPString)username
{
    var method = @"flickr.people.findByUsername";
    
    var connectionOptions = [CPDictionary dictionaryWithObjects:[method, username] forKeys:[@"method", @"username"]];
    
    [self createAndStartConnectionWithOptions:connectionOptions];
}

// http://www.flickr.com/services/api/flickr.contacts.getPublicList.html
- (void)getContactsForUser:(CPString)user_id
{
    var method = @"flickr.contacts.getPublicList";
    
    var connectionOptions = [CPDictionary dictionaryWithObjects:[method, user_id] forKeys:[@"method", @"user_id"]];
    
    [self createAndStartConnectionWithOptions:connectionOptions];
}

// http://www.flickr.com/services/api/flickr.people.getPublicGroups.html
- (void)getGroupsForUser:(CPString)user_id
{
    var method = @"flickr.people.getPublicGroups";
    
    var connectionOptions = [CPDictionary dictionaryWithObjects:[method, user_id] forKeys:[@"method", @"user_id"]];
    
    [self createAndStartConnectionWithOptions:connectionOptions];
}

// http://www.flickr.com/services/api/flickr.favorites.getPublicList.html
- (void)getFavoritesForUser:(CPString)user_id
{
    var method = @"flickr.favorites.getPublicList";
    
    var connectionOptions = [CPDictionary dictionaryWithObjects:[method, user_id] forKeys:[@"method", @"user_id"]];
    
    [self createAndStartConnectionWithOptions:connectionOptions];
}

// http://www.flickr.com/services/api/flickr.people.getPublicPhotos.html
- (void)getPhotosForUser:(CPString)user_id
{
    var method = @"flickr.people.getPublicPhotos";
    
    var connectionOptions = [CPDictionary dictionaryWithObjects:[method, user_id] forKeys:[@"method", @"user_id"]];
    
    [self createAndStartConnectionWithOptions:connectionOptions];
}

// http://www.flickr.com/services/api/flickr.photosets.getPhotos.html
- (void)getPhotosForPhotoset:(CPString)photoset_id
{
    var method = @"flickr.photosets.getPhotos";
    
    var connectionOptions = [CPDictionary dictionaryWithObjects:[method, photoset_id] forKeys:[@"method", @"photoset_id"]];
    
    [self createAndStartConnectionWithOptions:connectionOptions];    
}

// http://www.flickr.com/services/api/flickr.groups.pools.getPhotos.html
- (void)getPhotosForGroup:(CPString)group_id
{
    var method = @"flickr.groups.pools.getPhotos";
    
    var connectionOptions = [CPDictionary dictionaryWithObjects:[method, group_id] forKeys:[@"method", @"group_id"]];
    
    [self createAndStartConnectionWithOptions:connectionOptions];
}

@end

@implementation FlickrController (CPJSONPConnectionDelegate)

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPString)data
{
    if (data.stat === @"fail")
    {
        [self connection:connection didFailWithError:data.message];
        return;
    }
    
    //console.log(@"Received data:", data);

    var connectionOptions = [connections objectForKey:connection];
    var method = [connectionOptions objectForKey:@"method"];

    switch (method)
    {
        case @"flickr.photosets.getList":
            var userInfo = connectionOptions;
            [userInfo setObject:data.photosets.photoset forKey:@"albums"];
            [[CPNotificationCenter defaultCenter]
                postNotificationName:FlickrControllerDidGetPhotosetsForUser
                object:self
                userInfo:userInfo];
            break;
        case @"flickr.people.findByUsername":
            var userInfo = connectionOptions;
            [userInfo setObject:data.user.nsid forKey:@"user_id"];
            [[CPNotificationCenter defaultCenter]
                postNotificationName:FlickrControllerDidGetUserByUsername
                object:self
                userInfo:userInfo];
            break;
        case @"flickr.contacts.getPublicList":
            var userInfo = connectionOptions;
            [userInfo setObject:data.contacts.contact forKey:@"contacts"];
            [[CPNotificationCenter defaultCenter]
                postNotificationName:FlickrControllerDidGetContactsForUser
                object:self
                userInfo:userInfo];
            break;
        case @"flickr.people.getPublicGroups":
            var userInfo = connectionOptions;
            [userInfo setObject:data.groups.group forKey:@"groups"];
            [[CPNotificationCenter defaultCenter]
                postNotificationName:FlickrControllerDidGetGroupsForUser
                object:self
                userInfo:userInfo];
            break;
        case @"flickr.favorites.getPublicList":
            var userInfo = connectionOptions;
            [userInfo setObject:data.photos.photo forKey:@"favorites"];
            [[CPNotificationCenter defaultCenter]
                postNotificationName:FlickrControllerDidGetFavoritesForUser
                object:self
                userInfo:userInfo];
            break;
        case @"flickr.photosets.getPhotos":
            var userInfo = connectionOptions;
            [userInfo setObject:data.photoset.photo forKey:@"photos"];
            [[CPNotificationCenter defaultCenter]
                postNotificationName:FlickrControllerDidGetPhotosForPhotoset
                object:self
                userInfo:userInfo];
            break;
        case @"flickr.groups.pools.getPhotos":
            var userInfo = connectionOptions;
            [userInfo setObject:data.photos.photo forKey:@"photos"];
            [[CPNotificationCenter defaultCenter]
                postNotificationName:FlickrControllerDidGetPhotosForGroup
                object:self
                userInfo:userInfo];
            break;
        case @"flickr.people.getPublicPhotos":
            var userInfo = connectionOptions;
            [userInfo setObject:data.photos.photo forKey:@"photos"];
            [[CPNotificationCenter defaultCenter]
                postNotificationName:FlickrControllerDidGetPhotosForUser
                object:self
                userInfo:userInfo];
            break;
        default:
            console.warn(@"Unhandled case in", _cmd);
            break;
    }
}

- (void)connection:(CPJSONPConnection)connection didFailWithError:(CPString)error
{
    console.error(error);
}

@end