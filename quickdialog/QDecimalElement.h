//                                
// Copyright 2011 ESCOZ Inc  - http://escoz.com
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import <Foundation/Foundation.h>
#import "QEntryElement.h"

@interface QDecimalElement : QEntryElement {

}

// Hsoi 2013-06-10 - original author had declared -floatValue to be a 'float' originally but changed
// it in commit ea57ca6581be166dbca339548b2902366677b2ee to be an 'NSNumber' to be easier on bindings.
// Alas, this makes it rougher on dynamic typing because we now have a system where -floatValue
// could return a float or could return an NSNumber and it's ambiguous for the compiler.
//
// So to work around this, I'm going to rename his stuff to be 'floatNumber'
//
// see: https://github.com/escoz/QuickDialog/commit/ea57ca6581be166dbca339548b2902366677b2ee#commitcomment-3390464
@property(nonatomic, retain) NSNumber * floatNumber;
@property(nonatomic, assign) NSUInteger fractionDigits;

- (QDecimalElement *)initWithTitle:(NSString *)string value:(NSNumber *)value;
- (QDecimalElement *)initWithValue:(NSNumber *)value;

@end
