#import <Foundation/Foundation.h>
#import "QEntryElement.h"
#import "QPickerValueParser.h"

@interface QPickerElement : QEntryElement
{
@protected
    id<QPickerValueParser> _valueParser;
}

@property (nonatomic, strong) id<QPickerValueParser> valueParser;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, readonly) NSArray *selectedIndexes;

@property (nonatomic, strong) NSString* selectedItemsString; // Hsoi 11-Sep-2012 - added

- (QPickerElement *)initWithTitle:(NSString *)title items:(NSArray *)items value:(id)value;

- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)index;

@end
