//
//  User.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/24/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "User.h"

@implementation User

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
        _userID = [aDecoder decodeObjectForKey:@"userID"];
        _userName = [aDecoder decodeObjectForKey:@"username"];
        _firstName = [aDecoder decodeObjectForKey:@"firstname"];
        _lastName = [aDecoder decodeObjectForKey:@"lastname"];
        _email = [aDecoder decodeObjectForKey:@"email"];
        _password = [aDecoder decodeObjectForKey:@"password"];
        _confirmPassword = [aDecoder decodeObjectForKey:@"confirm_password"];
        _gender = [aDecoder decodeObjectForKey:@"gender"];
        _city = [aDecoder decodeObjectForKey:@"city"];
        _state = [aDecoder decodeObjectForKey:@"state"];
        _zip = [aDecoder decodeObjectForKey:@"zip"];
        _country = [aDecoder decodeObjectForKey:@"country"];
        _bio = [aDecoder decodeObjectForKey:@"bio"];
        _contactNumber = [aDecoder decodeObjectForKey:@"contact"];
        _dirName = [aDecoder decodeObjectForKey:@"dirname"];
        _logo = [aDecoder decodeObjectForKey:@"logo"];
        
    }
    
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_userID forKey:@"userID"];
    [aCoder encodeObject:_userName forKey:@"username"];
    [aCoder encodeObject:_firstName forKey:@"firstname"];
    [aCoder encodeObject:_lastName forKey:@"lastname"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_confirmPassword forKey:@"confirm_password"];
    [aCoder encodeObject:_gender forKey:@"gender"];
    [aCoder encodeObject:_city forKey:@"city"];
    [aCoder encodeObject:_state forKey:@"state"];
    [aCoder encodeObject:_zip forKey:@"zip"];
    [aCoder encodeObject:_country forKey:@"country"];
    [aCoder encodeObject:_bio forKey:@"bio"];
    [aCoder encodeObject:_contactNumber forKey:@"contact"];
    [aCoder encodeObject:_dirName forKey:@"dirname"];
    [aCoder encodeObject:_logo forKey:@"logo"];
    
}


-(id)copyWithZone:(NSZone *)zone {
    
    User * newUser = [[User alloc]init];
    
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
    
    return newUser;
}


+(User *)parseUserFromDictionary:(NSDictionary *)data {
    User * artist = [[User alloc]init];
    artist.userID = data[@"listener_id"];
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
