//
//  Artist.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/24/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "Artist.h"

@implementation Artist
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _paypalEmail = [aDecoder decodeObjectForKey:@"paypalEmail"];
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_paypalEmail forKey:@"paypalEmail"];
}


-(id)copyWithZone:(NSZone *)zone {
    
    Artist * newUser = [[Artist alloc]init];
    
    newUser.userID = [self.userID copy];
    newUser.firstName = [self.firstName copy];
    newUser.lastName = [self.lastName copy];
    newUser.userName = [self.userName copy];
    newUser.email = [self.email copy];
    newUser.password = [self.password copy];
    newUser.confirmPassword = [self.confirmPassword copy];
    newUser.gender = [self.gender copy];
    newUser.city = [self.city copy];
    newUser.state = [self.state copy];
    newUser.zip = [self.zip copy];
    newUser.country = [self.country copy];
    newUser.bio = [self.bio copy];
    newUser.contactNumber = [self.contactNumber copy];
    newUser.dirName = [self.dirName copy];
    newUser.logo = [self.logo copy];
    newUser.paypalEmail = [self.paypalEmail copy];
    
    return newUser;
}

+(Artist *)parseArtistFromDictionary:(NSDictionary *)data {
    
    Artist * artist = [[Artist alloc]init];
    artist.userID = data[@"artist_id"];
    artist.userName = data[@"username"];
    artist.firstName = data[@"firstname"];
    artist.lastName = data[@"lastname"];
    artist.password = @"";
    artist.confirmPassword = @"";
    artist.email = data[@"email"];
    artist.gender = data[@"gender"];
    artist.city = data[@"city"];
    artist.state = data[@"state"];
    artist.zip = @"";
    artist.country = data[@"country"];
    artist.logo = data[@"logo"];
    artist.dirName = data[@"dir_name"];
    artist.bio = @"";
    artist.contactNumber = @"";
    return artist;
    
}


@end
