//
//  LocalStorage.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/25/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "LocalStorage.h"
#define kLogin @"login"

@implementation LocalStorage

#pragma mark - User Operations

+(BOOL)checkIfLoggedIn {
    NSString * user = [[NSUserDefaults standardUserDefaults] objectForKey:kLogin];
    if (user == nil) {
        return NO;
    }
    return YES;
}

+(void)saveNewUser:(id)user type:(UserType)type {
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    if (type == kUserTypeArtist) {
        Artist * artist = (Artist *)user;
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:artist];
        [userDefaults setObject:encodedObject forKey:@"user"];
        
        [userDefaults setObject:@"artist" forKey:@"userType"];
        [userDefaults setObject:@"YES" forKey:kLogin];
        [userDefaults synchronize];
    }
    else if (type == kUserTypeListener){
        User * listener = (User *)user;
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:listener];
        [userDefaults setObject:encodedObject forKey:@"user"];
        
        [userDefaults setObject:@"listener" forKey:@"userType"];
        [userDefaults setObject:@"YES" forKey:kLogin];
        [userDefaults synchronize];
    }
    else{
        User * listener = (User *)user;
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:listener];
        [userDefaults setObject:nil forKey:@"user"];
        
        [userDefaults setObject:nil forKey:@"userType"];
        [userDefaults setObject:nil forKey:kLogin];
        [userDefaults synchronize];
        NSLog(@"invalid user type");
    }
}

+(id)getCurrentSavedUser {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    id user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (user != nil) {
        return user;
    }
    NSLog(@"user not found");
    return nil;
}

+(UserType)getSaveUserType {
    NSString * userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"userType"];
    if (userType != nil) {
        return [userType isEqualToString:@"artist"] ? kUserTypeArtist : kUserTypeListener;
    }
    else {
        NSLog(@"no user type found");
        return -1;
    }
}


#pragma mark - Local Stored Songs


+(NSString *)pathForSongsPlist {
    NSString * fileName = [NSString stringWithFormat:@"songs-%@.plist",((User *)[LocalStorage getCurrentSavedUser]).userID];
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
}


+(NSArray <Song *> *)listOfAllSavedSongs {
//    NSString * path = [self pathForSongsPlist];
//    NSArray * songsArray = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSData alloc] initWithContentsOfFile:path]];
//    NSLog(@"%@ song arr",songsArray.description);
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    
    NSLog(@"files array %@", filePathsArray);

    return (filePathsArray == nil ? @[] : filePathsArray);
}

+(Song *)getSongOfName:(NSString *)fileName {
    NSString * path = [self pathForSongsPlist];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"song file doesnot exist");
        return nil;
    }
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSMutableArray <Song *> * songsArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    int index = -1;
    for (int i=0; i<songsArray.count; ++i) {
        if ([songsArray[i].fileName isEqualToString:fileName]) {
            index = i;
            break;
        }
    }
    if (index >= 0) {
        return songsArray[index];
    }
    
    NSLog(@"song Not found for name %@",fileName);
    return nil;
    
}


+(BOOL)removeSongFromLocalStorage:(Song *)song{
    NSString * path = [self pathForSongsPlist];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"song file doesnot exist");
        return NO;
    }
    
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSMutableArray <Song *> * songsArray = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
    int index = -1;
    
    for (int i=0; i<songsArray.count; ++i) {
        if ([song.songID isEqualToString:songsArray[i].songID]) {
            index = i;
            break;
        }
    }
    
    if (index >= 0) {
        [songsArray removeObjectAtIndex:index];
        data = [NSKeyedArchiver archivedDataWithRootObject:songsArray];
        [data writeToFile:path atomically:YES];
        NSError * error = nil;
        [[NSFileManager defaultManager]removeItemAtPath:[[self pathForMyDocumentsDirectory]stringByAppendingPathComponent:song.fileName] error:&error];
        
        if (!error) {
            return YES;
        }
        
        NSLog(@"Error Deleting song file");
        return NO;
    }
    
    else {
        NSLog(@"song Not found for removing");
        return NO;
    }
    
}


+(BOOL)addSongToLocalStorage:(Song *)song songData:(NSData *)songData{
    if (songData) {
        BOOL result = [songData writeToFile:[[self pathForMyDocumentsDirectory]stringByAppendingPathComponent:song.fileName] atomically:YES];
        if (result) {
            [self addSongToLocalStorage:song];
        }
        return result;
    }
    else {
        NSLog(@"song Data is nil");
        return NO;
    }
}


+(void)addSongToLocalStorage:(Song *)song{
    if (song != nil) {
        
        NSString * path = [self pathForSongsPlist];
        if (![[NSFileManager defaultManager]fileExistsAtPath:path]){
            [[NSFileManager defaultManager]createFileAtPath:path contents:[NSKeyedArchiver archivedDataWithRootObject:@[song]] attributes:nil];
        }
        
        else {
            NSData * data = [[NSData alloc]initWithContentsOfFile:path];
            NSMutableArray * songsArray = [(NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
            [songsArray addObject:song];
            [[NSKeyedArchiver archivedDataWithRootObject:songsArray]writeToFile:path atomically:YES];
        }
    }
    
}

+(NSString *)pathForMyDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}



@end