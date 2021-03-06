// 
//  Favorite.m
//  iBurn
//
//  Created by Andrew Johnson on 8/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Favorite.h"
#import "util.h"
#import "JSONKit.h"

#import "ArtInstall.h"
#import "Event.h"
#import "ThemeCamp.h"

@implementation Favorite 

@dynamic ThemeCamp;
@dynamic Event;
@dynamic ArtInstall;

+ (NSString*) fileUrl {
  return [privateDocumentsDirectory() stringByAppendingPathComponent:@"favorites.json"];
}


+ (NSMutableDictionary*) favorites {
  static NSMutableDictionary * favorites = nil;
  if (!favorites) {
    NSData * fileData = [NSData dataWithContentsOfFile:[self fileUrl]];
    if (fileData) {
      favorites = [fileData mutableObjectFromJSONData];
    } else {
      favorites = [NSMutableDictionary dictionary];
      [favorites setObject:[NSMutableArray array] forKey:@"ArtInstall"];
      [favorites setObject:[NSMutableArray array] forKey:@"Event"];
      [favorites setObject:[NSMutableArray array] forKey:@"ThemeCamp"];
    }
  }
  return favorites;
}


+ (void) save {
  NSData * data = [[Favorite favorites] JSONData];
  [data writeToFile:[self fileUrl] atomically:NO];
}


+ (void) addFavorite:(NSString*) type id:(NSNumber*)bm_id {
  NSMutableArray * typeArray = [[Favorite favorites] objectForKey:type];
  if ([typeArray containsObject:bm_id]) {
    [typeArray removeObject:bm_id];
  } else {
    [typeArray addObject:bm_id];
  }
  [Favorite save];
}


+ (BOOL) isFavorite:(NSString*) type id:(NSNumber*)bm_id {
  NSMutableArray * typeArray = [[Favorite favorites] objectForKey:type];
  for (NSNumber * num in typeArray) {
    if ([num isEqualToNumber:bm_id]) {
      return YES;
    }
  }
  return NO;
}

+ (NSArray*) favoritesForType:(NSString*) type {
  return [[Favorite favorites] objectForKey:type];

}

+ (NSString*) selectedString:(NSString*) type id:(NSNumber*) bm_id {
  return [NSString stringWithFormat:@"%@%d", type, [bm_id intValue]];
}

+ (void) setSelected:(NSString*) type id:(NSNumber*)bm_id {
  [[Favorite favorites] setObject:[Favorite selectedString:type id:bm_id] forKey:@"selected"];
  [Favorite save];
}

+ (BOOL) isSelected:(NSString*) type id:(NSNumber*)bm_id {
  NSString * selectedString = [[Favorite favorites] objectForKey:@"selected"];
  if ([selectedString isEqualToString:[Favorite selectedString:type id:bm_id]]) {
    return YES;
  }
  return NO;
}





@end
