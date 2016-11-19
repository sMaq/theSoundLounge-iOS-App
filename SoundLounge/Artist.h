//
//  Artist.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/24/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "User.h"

@interface Artist : User <NSCopying, NSCoding>
@property NSString * paypalEmail;

+(Artist *)parseArtistFromDictionary:(NSDictionary *)data;

@end
