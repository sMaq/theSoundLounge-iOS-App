//
//  Song.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 6/5/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "Song.h"

@implementation Song

-(id)copyWithZone:(NSZone *)zone {
    Song * newSong = [[Song alloc]init];
    newSong.songID = self.songID;
    newSong.songLocalURL = self.songLocalURL;
    newSong.fileName = self.fileName;
    return newSong;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_songID forKey:@"songID"];
    [aCoder encodeObject:_fileName forKey:@"fileName"];
    [aCoder encodeObject:_songLocalURL forKey:@"path"];
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        _songID = [aDecoder decodeObjectForKey:@"songID"];
        _fileName = [aDecoder decodeObjectForKey:@"fileName"];
        _songLocalURL = [aDecoder decodeObjectForKey:@"path"];

    }
    return self;
}

@end
