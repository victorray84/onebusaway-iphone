//
//  OBAClassicDepartureCell.h
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 3/6/16.
//  Copyright © 2016 OneBusAway. All rights reserved.
//

@import UIKit;
#import "OBATableCell.h"
#import "AFMSlidingCell.h"

@interface OBAClassicDepartureCell : AFMSlidingCell<OBATableCell>
@property(nonatomic,assign) BOOL expanded;
@end
