//
//  LocalStorage.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/25/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Song.h"

typedef enum UserType{
    kUserTypeArtist,
    kUserTypeListener,
    kUserTypeLogOut
}UserType;

@interface LocalStorage : NSObject

+(BOOL)checkIfLoggedIn;
+(id)getCurrentSavedUser;
+(void)saveNewUser:(id)user type:(UserType)type;
+(UserType)getSaveUserType;
+(NSArray <Song *> *)listOfAllSavedSongs;
+(Song *)getSongOfName:(NSString *)fileName;
+(BOOL)removeSongFromLocalStorage:(Song *)song;
+(BOOL)addSongToLocalStorage:(Song *)song songData:(NSData *)songData;
+(void)addSongToLocalStorage:(Song *)song;
@end
