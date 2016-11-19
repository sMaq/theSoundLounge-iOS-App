//
//  User.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/24/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCopying,NSCoding>

@property NSString * userID;
@property NSString * userName;
@property NSString * firstName;
@property NSString * lastName;
@property NSString * password;
@property NSString * confirmPassword;
@property NSString * email;
@property NSString * gender;
@property NSString * city;
@property NSString * state;
@property NSString * zip;
@property NSString * country;
@property NSString * bio;
@property NSString * contactNumber;
@property NSString * dirName;
@property NSString * logo;


+(User *)parseUserFromDictionary:(NSDictionary *)data;


@end
