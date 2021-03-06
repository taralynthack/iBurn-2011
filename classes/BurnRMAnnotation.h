//
//  BurnRMAnnotation.h
//  iBurn
//
//  Created by Andrew Johnson on 8/3/13.
//
//

#import "RMAnnotation.h"

@interface BurnRMAnnotation : RMAnnotation

@property(nonatomic, strong) NSNumber* burningManID;
@property(nonatomic, assign) BOOL favorite;
@property(nonatomic, retain) NSDate * startDate;


- (BOOL) isFavorite;
- (BOOL) isSelected;

@end
