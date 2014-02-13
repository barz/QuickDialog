//
//  QPickerTabDelimitedStringParser.m
//  QuickDialog
//
//  Created by HiveHicks on 05.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QPickerTabDelimitedStringParser.h"

@implementation QPickerTabDelimitedStringParser

- (id)objectFromComponentsValues:(NSArray *)componentsValues
{
    // Hsoi 2014-02-13 - tabs seem to cause weird spacing problems, especially with
    // right-justified text and proportional-width fonts. Sometimes the "columns"
    // wind up slammed against each other, sometimes they are spaced out.. it's all
    // just the way things calculate out.
    //
    // We found using spaces at least makes things a little more deterministic. So
    // we're going to use 2 spaces instead of a tab.
    NSString* delimiter = @"  "; // @"\t";
    return [componentsValues componentsJoinedByString:delimiter];
}

- (NSArray *)componentsValuesFromObject:(id)object
{
    // Hsoi 2014-02-13 - tabs seem to cause weird spacing problems, especially with
    // right-justified text and proportional-width fonts. Sometimes the "columns"
    // wind up slammed against each other, sometimes they are spaced out.. it's all
    // just the way things calculate out.
    //
    // We found using spaces at least makes things a little more deterministic. So
    // we're going to use 2 spaces instead of a tab.
    NSString* delimiter = @"  "; // @"\t";
    NSString *stringValue = [object isKindOfClass:[NSString class]] ? object : [object description];
    return [stringValue componentsSeparatedByString:delimiter];
}

@end
