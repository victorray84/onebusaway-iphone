//
//  OBAArrivalAndDepartureSectionBuilder.m
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 7/13/16.
//  Copyright © 2016 OneBusAway. All rights reserved.
//

#import "OBAArrivalAndDepartureSectionBuilder.h"

@implementation OBAArrivalAndDepartureSectionBuilder

+ (OBADepartureRow *)createDepartureRow:(OBAArrivalAndDepartureV2*)arrivalAndDeparture {
    OBAGuard(arrivalAndDeparture) else {
        return nil;
    }

    OBADepartureRow *row = [[OBADepartureRow alloc] initWithAction:nil];

    row.routeName = arrivalAndDeparture.bestAvailableName;
    row.destination = arrivalAndDeparture.tripHeadsign;
    row.statusText = [OBADepartureCellHelpers statusTextForArrivalAndDeparture:arrivalAndDeparture];

    OBAUpcomingDeparture *upcoming = [[OBAUpcomingDeparture alloc] initWithDepartureDate:arrivalAndDeparture.bestArrivalDepartureDate departureStatus:arrivalAndDeparture.departureStatus arrivalDepartureState:arrivalAndDeparture.arrivalDepartureState];
    row.upcomingDepartures = @[upcoming];

    return row;
}

@end
