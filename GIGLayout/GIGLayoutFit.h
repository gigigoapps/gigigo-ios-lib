//
//  GIGLayoutFit.h
//  layout
//
//  Created by Sergio Baró on 06/02/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#ifndef layout_GIGLayoutFit_h
#define layout_GIGLayoutFit_h


__unused NSArray* gig_layout_fit_horizontal(UIView *subview)
{
    NSArray *constraints = gig_constraints(@"H:|[subview]|", nil, GIGViews(subview));
    [subview.superview addConstraints:constraints];
    
    return constraints;
}

__unused NSArray* gig_layout_fit_vertical(UIView *subview)
{
    NSArray *constraints = gig_constraints(@"V:|[subview]|", nil, GIGViews(subview));
    [subview.superview addConstraints:constraints];
    
    return constraints;
}

__unused NSArray* gig_layout_fit(UIView *subview)
{
    NSArray *horizontal = gig_layout_fit_horizontal(subview);
    NSArray *vertical = gig_layout_fit_vertical(subview);
    
    return [[NSArray arrayWithArray:horizontal] arrayByAddingObjectsFromArray:vertical];
}


#endif
