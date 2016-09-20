//
//  Resaurant.m
//  ChadsMKMapViewApp
//
//  Created by Chad Wiedemann on 9/16/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import "Resaurant.h"

@implementation Resaurant


- (id)initWithLocation:(CLLocationCoordinate2D)coord title:(NSString*) title{
    self = [super init];
    if (self) {
        _coordinate = coord;
        _title = title;
    }
    return self;
}

-(MKPinAnnotationView*)annotationView
{
    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"identifier"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    UIImage *image1 = [UIImage imageNamed: self.imageString];
    UIImage *newImage = [self imageWithImage:image1 scaledToWidth:40];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:newImage];
    annotationView.contentMode = UIViewContentModeScaleAspectFit;
    
    annotationView.leftCalloutAccessoryView = image ;
    return annotationView;
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

    
@end
