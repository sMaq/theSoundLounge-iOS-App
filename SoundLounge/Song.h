//
//  Song.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/5/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject <NSCoding, NSCopying>

@property NSString * songID;
@property NSString * songLocalURL;
@property NSString * fileName;

@end
