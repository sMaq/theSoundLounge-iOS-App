//
//  WebAPI.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/24/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artist.h"

#define API_URL @"http://thesound-lounge.com/lounge/api/api.php?"

#define kError_Network @"There was an error while connecting with server. Please try again"

@interface WebAPI : NSObject

+(void)searchKeyword:(NSString *)keyword WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;

+(void)addLikeToPost:(NSString *)postID  andUserId:(NSString *)userID WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)addPostWithMessage:(NSString *)msg andPostImage:(NSString *)image WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)unlikePost:(NSString *)postID andUserId:(NSString *)userID WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)deleteCommentWithUserId:(NSString *)postID andUserId:(NSString *)userID WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;

+(void)getNowStreamingAlbumsWithCategoryID:(NSString *)categoryID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getSongsByAlbumForStreaming:(NSString *)categoryID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getNewArtistWallFeedsWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)getNewArtistWallFeedsWithArtistID:(NSString*)artistId   WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)getNewArtistAlbumsWithArtistID:(NSString *)artistID WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)getLatestArtistAlbumsWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)getFollowArtistAlbumsWithArtistId:(NSString*)artistID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)addEventWithName:(NSString *)name eventDescription:(NSString *)eventDescription location:(NSString *)location startDate:(NSString *)startDate endDate:(NSString *)endDate image:(NSString *)imageString CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;

+(void)addAlbumWithName:(NSString *)name category:(NSString *)category type:(NSString *)type artist_id:(NSString *)artist_id image:(NSString *)imageString CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)contactUSWithName:(NSString *)name email:(NSString *)email message:(NSString *)message CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)updateAlbumWithName:(NSString *)name albumid:(NSString *)albumid category:(NSString *)category type:(NSString *)type artist_id:(NSString *)artist_id image:(NSString *)imageString CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)deleteAlbumWithAlbumID:(NSString *)albumID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)FollowAlbumWithAlbumID:(NSString *)albumID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)unFollowAlbumWithAlbumID:(NSString *)albumID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)updateEventWithEventID:(NSString *)eventID name:(NSString *)name eventDescription:(NSString *)eventDescription location:(NSString *)location startDate:(NSString *)startDate endDate:(NSString *)endDate image:(NSString *)imageString CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;

+(void)deleteEvent:(NSString *)eventID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;

+(void)getEventsWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)getAlbumsWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)getArtistData:(NSString *)artistID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)getcityStateCountryWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock;
+(void)getTrendingPlaylistWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getGenereCategoriesWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)getTrendingArtistsWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getGenereWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getTrendingGenereWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getAlbumByCategory:(NSString *)categoryID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getSongsByAlbum:(NSString *)albumID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)getSongsByAlbumForStreaming2:(NSString *)albumID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)downloadSong:(NSString *)songID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getCommentsOfUserID:(NSString *)userID userType:(NSString *)userType CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getWallPostsOfUserID:(NSString *)userID userType:(NSString *)userType CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getAlbumsByArtist:(NSString *)userID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getFreeBiesWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getExclusiveFreeBiesWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getUnsignedHypesWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)registerUser:(User *)user completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)updateUser:(User *)user completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)registerArtist:(Artist *)artist completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)updateArtist:(Artist *)artist completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)loginListenerWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock ;

+(void)loginArtistWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)ForgotPassWithEmail:(NSString *)email type:(NSString *)type completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getFavoruiteSongsWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)getFavoruiteAlbumsWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;

+(void)addFavouriteAlbumWithAlbumID:(NSString *)albumID completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)deleteFavouriteAlbumWithAlbumID:(NSString *)albumID completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)addFavouriteSongWithMusicID:(NSString *)musicID albumID:(NSString *)albumID completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock;
+(void)deleteFavouriteSongWithMusicID:(NSString *)musicID albumID:(NSString *)albumID completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock ;


@end
