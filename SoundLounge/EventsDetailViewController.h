//
//  EventsDetailViewController.h
//  SoundLounge
//
//  Created by Bilal Ashraf on 5/28/16.
//  Copyright © 2016 KamHere. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : int {
    kEventUpdate =0,
    kEventAdd = 1
} kEventType;


@interface EventsDetailViewController : UITableViewController{
    kEventType operationType;
}

@end
