//
//  CampInfoViewController.m
//  iBurn
//
//  Created by Jeffrey Johnson on 2009-01-18.
//  Copyright 2009 Burning Man Earth. All rights reserved.
//

#import "CampInfoViewController.h"
#import "CampTableViewController.h"
#import "Favorite.h"
#import "iBurnAppDelegate.h"
#import "MyCLController.h"
#import "MapViewController.h"
#import "util.h"

@implementation CampInfoViewController

@synthesize camp;


- (void) setFavButton {
  NSString *imgName = @"empty_star.png";
  if ([Favorite isFavorite:THEME_CAMP_TYPE id:camp.bm_id]) {
    imgName = @"full_star.png";
  }
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithImage:[UIImage imageNamed:imgName]
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(addToFavorites:)];

}


- (void) showOnMap {
  [Favorite setSelected:@"ThemeCamp" id:camp.bm_id];

	iBurnAppDelegate *t = (iBurnAppDelegate *)[[UIApplication sharedApplication] delegate];
  [[t tabBarController]setSelectedViewController:[[[t tabBarController]viewControllers]objectAtIndex:0]];
  [[[[t tabBarController]viewControllers]objectAtIndex:0] popToRootViewControllerAnimated:YES];
  MapViewController *mapViewController = (MapViewController*)[[[[t tabBarController]viewControllers]objectAtIndex:0]visibleViewController];
  [mapViewController showMapForObject:camp];
}


- (void) setupViewInfo {
  NSMutableArray *tempTitles = [[NSMutableArray alloc]init];
  NSMutableArray *tempTexts = [[NSMutableArray alloc]init];
  if (camp.name && ![camp.name isEqualToString:@""]) {
    [tempTitles addObject:@"Name"];
    if ([camp.latitude floatValue] > 1 
        && [camp.longitude floatValue] < -1) {
      CLLocation *loc = [[CLLocation alloc]initWithLatitude:[camp.latitude floatValue] longitude:[camp.longitude floatValue]];
      
      float distanceAway = [[MyCLController sharedInstance] currentDistanceToLocation:loc];
      if (distanceAway > 0) {
        [tempTexts addObject:[camp.name stringByAppendingFormat:@" (%@)",
                              [util distanceString:distanceAway convertMax:1000 includeUnit:YES decimalPlaces:2]]];
      } else {
        [tempTexts addObject:camp.name];
      }            
    } else {      
      [tempTexts addObject:camp.name];
    }
    
    
  }
  if (camp.contactEmail && ![camp.contactEmail isEqualToString:@""]) {
    [tempTitles addObject:@"Contact Email"];
    [tempTexts addObject:camp.contactEmail];
  }
  if (camp.url && ![camp.url isEqualToString:@""]) {
    [tempTitles addObject:@"URL"];
    if ([camp.url rangeOfString:@"http://"].location == NSNotFound) {
      camp.url = [@"http://" stringByAppendingString:camp.url]; 
    }
      [tempTexts addObject:camp.url];
  }
  if ([camp.latitude floatValue] > 1 
      && [camp.longitude floatValue] < -1) {
    [tempTitles addObject:@"Coordinates"];
		iBurnAppDelegate *t = (iBurnAppDelegate *)[[UIApplication sharedApplication] delegate];
		if ([t embargoed]) {
			[tempTexts addObject:@"Location data is embargoed until gates open."];
		} else {
			NSString *locString = [NSString stringWithFormat:@"%1.5f, %1.5f",[camp.latitude floatValue], [camp.longitude floatValue]];
			[tempTexts addObject:locString];
		}
  }
  if (camp.playaLocation && ![camp.playaLocation isEqualToString:@""]) {
    [tempTitles addObject:@"Playa Location"];
    iBurnAppDelegate *t = (iBurnAppDelegate *)[[UIApplication sharedApplication] delegate];
		if ([t embargoed]) {
			[tempTexts addObject:@"Location data is embargoed until gates open."];
		} else {
			[tempTexts addObject:camp.playaLocation];
		}
  }
  if (camp.location && ![camp.location isEqualToString:@""]) {
    [tempTitles addObject:@"Hometown"];
    [tempTexts addObject:camp.location];
  }
  if (camp.desc && ![camp.desc isEqualToString:@""] ) {
    [tempTitles addObject:@"Description"];
    [tempTexts addObject:camp.desc];
  }  
  cellTexts = tempTexts;
  headerTitles = tempTitles;
}

- (id)initWithCamp:(ThemeCamp*)cmp {
	self = [super initWithTitle:cmp.name];
	camp = cmp;
  [self setupViewInfo];
  return self;
}


- (CGFloat)tableView:(UITableView *)tb heightForRowAtIndexPath:(NSIndexPath *) indexPath {
  return [super tableView:tb heightForRowAtIndexPath:indexPath object:camp];  
}


- (void) addToFavorites: (id) sender {
  [Favorite addFavorite:@"ThemeCamp" id:camp.bm_id];
  [self setFavButton];
}

@end