//
//  WebAPI.m
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/24/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import "WebAPI.h"

@implementation WebAPI

#pragma mark - Helper Methods


+(void)searchKeyword:(NSString *)keyword WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/api/api.php?f_name=search&keyword=%@",keyword];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
    
}

+(void)addLikeToPost:(NSString *)postID andUserId:(NSString *)userID WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    
   // NSString * userID = @"89";
    
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    NSString * url = [NSString stringWithFormat:@"%@f_name=add_like",API_URL];
    
    [self sendRequestWithJSONData: [self createJSONString:
                                    @{
                                      @"user_id":userID,
                                      @"user_type":userType,
                                      @"wp_id":postID
                                      }
                                    ]
                              url:url method:@"POST" completionHandler:callbackBlock];
}
+(void)addPostWithMessage:(NSString *)msg andPostImage:(NSString *)image WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    
    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    NSString * url = [NSString stringWithFormat:@"%@f_name=add_wall_posts",API_URL];
    
    [self sendRequestWithJSONData: [self createJSONString:
                                    @{
                                      @"user_id":userID,
                                      @"user_type":userType,
                                      @"image":image,
                                      @"text":msg
                                      }
                                    ]
                              url:url method:@"POST" completionHandler:callbackBlock];
}


+(void)unlikePost:(NSString *)postID andUserId:(NSString *)userID WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    //NSString * userID = @"89";
    
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    NSString * url = [NSString stringWithFormat:@"%@f_name=delete_like",API_URL];
    
  //  [self sendRequestWithJSONData:nil url:url method:@"POST" completionHandler:callbackBlock];
    [self sendRequestWithJSONData: [self createJSONString:
                                    @{
                                      @"user_id":userID,
                                      @"user_type":userType,
                                      @"wp_id":postID
                                      }
                                    ]
                              url:url method:@"POST" completionHandler:callbackBlock];
}
+(void)deleteCommentWithUserId:(NSString *)postID andUserId:(NSString *)userID WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    //NSString * userID = @"89";
    
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    NSString * url = [NSString stringWithFormat:@"%@f_name=delete_comment",API_URL];
    
    //[self sendRequestWithJSONData:nil url:url method:@"POST" completionHandler:callbackBlock];
    [self sendRequestWithJSONData: [self createJSONString:
                                    @{
                                      @"user_id":userID,
                                      @"user_type":userType,
                                      @"wp_id":postID
                                      }
                                    ]
                              url:url method:@"POST" completionHandler:callbackBlock];
}

+(void)getNewArtistAlbumsWithArtistID:(NSString *)artistID WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_albums&artist_id=%@",API_URL,artistID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}
//http://thesound-lounge.com/lounge/api/api.php?f_name=latest_new_artist
+(void)getLatestArtistAlbumsWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=latest_new_artist",API_URL];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}
+(void)getFollowArtistAlbumsWithArtistId:(NSString*)artistID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    NSString * url = [NSString stringWithFormat:@"%@f_name=check_follow&user_id=%@&artist_id=%@",API_URL,userID,artistID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}
+(void)getNewArtistWallFeedsWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
//    
//    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    NSString * userID = @"89";
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_wall_posts&user_id=%@&user_type=%@",API_URL,userID,userType];
    
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];

}
+(void)getNewArtistWallFeedsWithArtistID:(NSString*)artistId   WithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    //
    //    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    NSString * userID = @"89";
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_wall_posts&user_id=%@&user_type=%@",API_URL,artistId,userType];
    
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
    
}

+(void)addEventWithName:(NSString *)name eventDescription:(NSString *)eventDescription location:(NSString *)location startDate:(NSString *)startDate endDate:(NSString *)endDate image:(NSString *)imageString CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * url = [NSString stringWithFormat:@"%@f_name=add_event",API_URL];
    
    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    
    
    [self sendRequestWithJSONData: [self createJSONString:
                                    @{@"name":name,
                                      @"description":eventDescription,
                                      @"start_date":startDate,
                                      @"end_date":endDate,
                                      @"location":location,
                                      @"user_id":userID,
                                      @"user_type":userType,
                                      @"image":imageString
                                      }
                                    ]
                              url:url method:@"POST" completionHandler:callbackBlock];
    
}
/////////Shahzaib Maqbool//////
+(void)deleteAlbumWithAlbumID:(NSString *)albumID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * url = [NSString stringWithFormat:@"%@f_name=delete_album",API_URL];
    
    [self sendRequestWithJSONData:[self createJSONString:@{@"album_id":albumID}] url:url method:@"POST" completionHandler:callbackBlock];
    
}
+(void)FollowAlbumWithAlbumID:(NSString *)albumID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    NSString * url = [NSString stringWithFormat:@"%@f_name=add_follower",API_URL];
    
    [self sendRequestWithJSONData:[self createJSONString:@{@"album_id":albumID,@"user_id":userID,@"user_type":userType}] url:url method:@"POST" completionHandler:callbackBlock];
    
}
+(void)unFollowAlbumWithAlbumID:(NSString *)albumID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    NSString * url = [NSString stringWithFormat:@"%@f_name=delete_follower&user_id=%@&followed_user=%@&user_type=%@",API_URL,albumID,userID,userType];
    
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
    
}
+(void)updateAlbumWithName:(NSString *)name albumid:(NSString *)albumid category:(NSString *)category type:(NSString *)type artist_id:(NSString *)artist_id image:(NSString *)imageString CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * url = [NSString stringWithFormat:@"%@f_name=update_album",API_URL];
    
    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    
    
    [self sendRequestWithJSONData: [self createJSONString:
                                    @{@"album_id":albumid,@"album_name":name,
                                      @"category":category,
                                      @"type":type,
                                      @"artist_id":userID,
                                      @"image":imageString
                                      }
                                    ]
                              url:url method:@"POST" completionHandler:callbackBlock];
    
}

+(void)addAlbumWithName:(NSString *)name category:(NSString *)category type:(NSString *)type artist_id:(NSString *)artist_id image:(NSString *)imageString CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * url = [NSString stringWithFormat:@"%@f_name=create_album",API_URL];
    
    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    
    
    [self sendRequestWithJSONData: [self createJSONString:
                                    @{@"album_name":name,
                                      @"category":category,
                                      @"type":type,
                                      @"artist_id":userID,
                                      @"image":imageString
                                      }
                                    ]
                              url:url method:@"POST" completionHandler:callbackBlock];
    
}
+(void)contactUSWithName:(NSString *)name email:(NSString *)email message:(NSString *)message CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * url = [NSString stringWithFormat:@"%@f_name=contact_us",API_URL];
    
    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    
    
    [self sendRequestWithJSONData: [self createJSONString:
                                    @{@"name":name,
                                      @"email":email,
                                      @"message":message
                                      }
                                    ]
                              url:url method:@"POST" completionHandler:callbackBlock];
    
}
+(void)updateEventWithEventID:(NSString *)eventID name:(NSString *)name eventDescription:(NSString *)eventDescription location:(NSString *)location startDate:(NSString *)startDate endDate:(NSString *)endDate image:(NSString *)imageString CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    
    //2015-08-18 04:33:00
    
    NSString * url = [NSString stringWithFormat:@"%@f_name=update_event",API_URL];
    
    NSString * userID = ((User *)[LocalStorage getCurrentSavedUser]).userID;
    NSString * userType = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    
    
    [self sendRequestWithJSONData: [self createJSONString:
                                    @{@"event_id":eventID,
                                      @"name":name,
                                      @"description":eventDescription,
                                      @"start_date":startDate,
                                      @"end_date":endDate,
                                      @"location":location,
                                      @"user_id":userID,
                                      @"user_type":userType,
                                      @"image":imageString
                                      }
                                    ]
                              url:url method:@"POST" completionHandler:callbackBlock];
    
}

+(void)deleteEvent:(NSString *)eventID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    
    NSString * url = [NSString stringWithFormat:@"%@f_name=delete_event",API_URL];
    
    [self sendRequestWithJSONData:[self createJSONString:@{@"event_id":eventID}] url:url method:@"POST" completionHandler:callbackBlock];
    
}


+(void)getEventsWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_events&user_id=%@",API_URL,((User *)[LocalStorage getCurrentSavedUser]).userID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)getAlbumsWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_albums&artist_id=%@",API_URL,((User *)[LocalStorage getCurrentSavedUser]).userID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}
+(void)getcityStateCountryWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_city_state_country",API_URL];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}
+(void)getArtistData:(NSString *)artistID CompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_artist&user_id=%@",API_URL,artistID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)getTrendingPlaylistWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * url = [NSString stringWithFormat:@"%@f_name=home_trending_list",API_URL];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}
+(void)getGenereCategoriesWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock{
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_genere",API_URL];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)getTrendingArtistsWithCompletionHandler:(void (^)(BOOL, NSArray *))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=trending_artists",API_URL];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}


+(void)getNowStreamingAlbumsWithCategoryID:(NSString *)categoryID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/api/api.php?f_name=album_by_category1&category_id=%@",categoryID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}


+(void)getGenereWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/api/api.php?f_name=get_all_categories1"];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}


+(void)getTrendingGenereWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=trending_genere",API_URL];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)getAlbumByCategory:(NSString *)categoryID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=album_by_category&category_id=%@",API_URL,categoryID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)getSongsByAlbum:(NSString *)albumID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=ios_songs_by_album&album_id=%@",API_URL,albumID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}
+(void)getSongsByAlbumForStreaming2:(NSString *)albumID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=songs_by_album1&album_id=%@",API_URL,albumID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)getSongsByAlbumForStreaming:(NSString *)categoryID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"http://thesound-lounge.com/lounge/api/api.php?f_name=album_by_category1&category_id=%@",categoryID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}



+(void)downloadSong:(NSString *)songID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=download_song&music_id=%@",API_URL,songID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}


+(void)getCommentsOfUserID:(NSString *)userID userType:(NSString *)userType CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_comments&user_id=%@&user_type=%@",API_URL,userID,userType];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}


+(void)getWallPostsOfUserID:(NSString *)userID userType:(NSString *)userType CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_wall_posts&user_id=%@&user_type=%@",API_URL,userID,userType];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}


+(void)getAlbumsByArtist:(NSString *)userID CompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=albums_by_artist&user_id=%@",API_URL,userID];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)getFreeBiesWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=free_bies",API_URL];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)getExclusiveFreeBiesWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=free_bies_exxclusive",API_URL];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)addFavouriteSongWithMusicID:(NSString *)musicID albumID:(NSString *)albumID completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * userID = ((User*)[LocalStorage getCurrentSavedUser]).userID;
    NSString * usertype = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    NSString * url = [NSString stringWithFormat:@"%@f_name=add_favorite",API_URL];
//    [self sendRequestWithJSONData:nil url:url method:@"POST" completionHandler:callbackBlock];
    
    [self sendRequestWithJSONData:[self createJSONString:@{
                                                           @"album_id":albumID,
                                                           @"user_id":userID,
                                                           @"user_type":usertype,
                                                           @"music_id":musicID
                                                           }]
                              url:url method:@"POST" completionHandler:callbackBlock];
}
+(void)deleteFavouriteSongWithMusicID:(NSString *)musicID albumID:(NSString *)albumID completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * userID = ((User*)[LocalStorage getCurrentSavedUser]).userID;
    NSString * usertype = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    NSString * url = [NSString stringWithFormat:@"%@f_name=delete_favorite_songs",API_URL];
    //    [self sendRequestWithJSONData:nil url:url method:@"POST" completionHandler:callbackBlock];
    
    [self sendRequestWithJSONData:[self createJSONString:@{
                                                           @"album_id":albumID,
                                                           @"user_id":userID,
                                                           @"user_type":usertype,
                                                           @"music_id":musicID
                                                           }]
                              url:url method:@"POST" completionHandler:callbackBlock];
}

+(void)addFavouriteAlbumWithAlbumID:(NSString *)albumID completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    
    NSString * userID = ((User*)[LocalStorage getCurrentSavedUser]).userID;
    NSString * usertype = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    NSString * url = [NSString stringWithFormat:@"%@f_name=add_favorite_album",API_URL];
    
    [self sendRequestWithJSONData:[self createJSONString:@{
                                                           @"album_id":albumID,
                                                           @"user_id":userID,
                                                           @"user_type":usertype
                                                           }]
                              url:url method:@"POST" completionHandler:callbackBlock];
}

+(void)deleteFavouriteAlbumWithAlbumID:(NSString *)albumID completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    
    NSString * userID = ((User*)[LocalStorage getCurrentSavedUser]).userID;
    NSString * usertype = [LocalStorage getSaveUserType] == kUserTypeArtist ? @"artist" : @"listener";
    NSString * url = [NSString stringWithFormat:@"%@f_name=delete_favorite_album",API_URL];
    
    [self sendRequestWithJSONData:[self createJSONString:@{
                                                           @"album_id":albumID,
                                                           @"user_id":userID,
                                                           @"user_type":usertype
                                                           }]
                              url:url method:@"POST" completionHandler:callbackBlock];
}

+(void)getUnsignedHypesWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=unsyned_hypes",API_URL];
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)getFavoruiteAlbumsWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    
    User * user = [LocalStorage getCurrentSavedUser];
    NSString * userID = user.userID;
    
    NSString * url = [LocalStorage getSaveUserType] == kUserTypeArtist ? [NSString stringWithFormat:@"%@f_name=get_favorite_albums&user_id=%@",API_URL,userID] : [NSString stringWithFormat:@"%@f_name=get_favorite_listner_albums&user_id=%@",API_URL,userID];
    
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)getFavoruiteSongsWithCompletionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    
    User * user = [LocalStorage getCurrentSavedUser];
    NSString * userID = user.userID;
    NSString * url = [NSString stringWithFormat:@"%@f_name=get_favorite_songs&user_id=%@",API_URL,userID];
    NSLog(@"URL :%@",url);
    
    [self sendRequestWithJSONData:nil url:url method:@"GET" completionHandler:callbackBlock];
}

+(void)registerUser:(User *)user completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=register_listner",API_URL];
    
    [self sendRequestWithJSONData:[self createJSONString:
                                   
                                   @{
                                     @"username":user.userName,
                                     @"firstname":user.firstName,
                                     @"lastname":user.lastName,
                                     @"password":user.password,
                                     @"confirm_password":user.confirmPassword,
                                     @"email":user.email
                                     
                                     }]
     
                              url:url method:@"POST" completionHandler:callbackBlock];
}
+(void)updateUser:(User *)user completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=update_listner_12",API_URL];
    User * user1 = [LocalStorage getCurrentSavedUser];
    NSString * userID = user1.userID;
    [self sendRequestWithJSONData:[self createJSONString:
                                   
                                   @{
                                     @"contact_no":user.contactNumber,
                                     @"listner_id":user1.userID,
                                     @"username":user.userName,
                                     @"firstname":user.firstName,
                                     @"lastname":user.lastName,
                                     @"password":user.password,
                                     @"confirm_password":user.confirmPassword,
                                     @"email":user.email,
                                     @"gender":user.gender,
                                     @"city":user.city,
                                     @"country":user.country,
                                     @"state":user.state,
                                     @"zip":user.zip
                                     
                                     }]
     
                              url:url method:@"POST" completionHandler:callbackBlock];
}


+(void)registerArtist:(Artist *)artist completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=register_artist",API_URL];
    [self sendRequestWithJSONData:[self createJSONString:
                                   
                                   @{
                                     @"username":artist.userName,
                                     @"firstname":artist.firstName,
                                     @"lastname":artist.lastName,
                                     @"password":artist.password,
                                     @"confirm_password":artist.confirmPassword,
                                     @"email":artist.email,
                                    
                                     @"bio":artist.bio,
                                     @"paypal_email":artist.paypalEmail
                                     }]
     
                              url:url method:@"POST" completionHandler:callbackBlock];
}
+(void)updateArtist:(Artist *)artist completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    Artist * user = [LocalStorage getCurrentSavedUser];
    NSString * userID = user.userID;
    
    NSString * url = [NSString stringWithFormat:@"%@f_name=update_artist",API_URL];
    //NSString * url = [NSString stringWithFormat:@"%@f_name=update_artist",API_URL];
    [self sendRequestWithJSONData:[self createJSONString:
                                   
                                   @{
                                     @"contact_no":artist.contactNumber,
                                     @"artist_id":user.userID,
                                     @"username":artist.userName,
                                     @"firstname":artist.firstName,
                                     @"lastname":artist.lastName,
                                     @"password":artist.password,
                                     @"confirm_password":artist.confirmPassword,
                                     @"email":artist.email,
                                     @"gender":artist.gender,
                                     @"city":artist.city,
                                     @"country":artist.country,
                                     @"state":artist.state,
                                     @"bmi":artist.bio,
                                     @"paypal_email":artist.paypalEmail,
                                     @"zip":artist.zip
                                     }]
     
                              url:url method:@"POST" completionHandler:callbackBlock];
}

+(void)loginListenerWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=login_listner",API_URL];
    [self sendRequestWithJSONData:[self createJSONString:
                                   @{
                                     @"email":email,
                                     @"password":password
                                     }]
                              url:url method:@"POST" completionHandler:callbackBlock];
    
}

+(void)ForgotPassWithEmail:(NSString *)email type:(NSString *)type  completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=forgot_password",API_URL];
    [self sendRequestWithJSONData:[self createJSONString:
                                   @{
                                     @"username":email,
                                     @"type":type
                                     }]
                              url:url method:@"POST" completionHandler:callbackBlock];
    
}
+(void)loginArtistWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock {
    NSString * url = [NSString stringWithFormat:@"%@f_name=login_artist",API_URL];
    [self sendRequestWithJSONData:[self createJSONString:
                                   @{
                                     @"email":email,
                                     @"password":password
                                     }]
                              url:url method:@"POST" completionHandler:callbackBlock];
    
}

+(void)sendRequestWithJSONData:(NSString*)data url:(NSString *)url method:(NSString *)method completionHandler:(void (^)(BOOL isError, NSArray * data))callbackBlock{
    // send method name in httpHeader keyValue...
    // send data if applicable in httpBody...
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    request.URL = [NSURL URLWithString:url];
    request.HTTPMethod = method;
    
    if (data != nil) {
        request.HTTPBody = [data dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 30;

    NSLog(@"URL: %@",url);
    NSLog(@"REQUEST:--------------------------------\n %@",[[NSString alloc]initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)response;
            
            NSString * dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"DATA: %@",dataString);
            NSLog(@"Status Code: %ld",(long)httpResponse.statusCode);
            NSArray * temp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            callbackBlock(NO,temp);
            
        } else {
            NSLog(@"Error: %@",error.description);
            callbackBlock(YES,nil);
        }
        
    }]resume];
}


+(NSString *)createJSONString:(NSDictionary *)dictionary{
    NSData * data =[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(NSDictionary *)createDictionaryFromJSON:(NSData *)jsonData{
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
}


@end
