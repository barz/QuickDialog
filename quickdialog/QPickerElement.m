#import "QPickerElement.h"
#import "QPickerTableViewCell.h"
#import "QPickerTabDelimitedStringParser.h"

@interface QPickerElement ()
@property (nonatomic, strong) NSString*     cachedItemsString;
@end

@implementation QPickerElement
{
@private
    NSArray *_items;
    
    UIPickerView *_pickerView;
}

@synthesize items = _items;
@synthesize valueParser = _valueParser;
@synthesize onValueChanged = _onValueChanged;
@dynamic selectedItemsString;  // Hsoi 11-Sep-2012 - added
@synthesize cachedItemsString;

- (QPickerElement *)init
{
    if (self = [super init]) {
        self.valueParser = [QPickerTabDelimitedStringParser new];
    }
    return self;
}

- (QPickerElement *)initWithTitle:(NSString *)title items:(NSArray *)items value:(id)value
{
    if ((self = [super initWithTitle:title Value:value])) {
        _items = items;
        self.valueParser = [QPickerTabDelimitedStringParser new];
    }
    return self;
}

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller
{
    QPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QPickerTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[QPickerTableViewCell alloc] init];
    }

    UIPickerView *pickerView = nil;
    [cell prepareForElement:self inTableView:tableView pickerView:&pickerView];
    _pickerView = pickerView;
    
    NSString* resetString = nil;
    if (self.cachedItemsString != nil) {
        resetString = self.cachedItemsString;
        self.cachedItemsString = nil;
    }
    [self setSelectedItemsString:resetString];
    [cell prepareForElement:self inTableView:tableView];
    
    cell.imageView.image = self.image;
    
    return cell;
}

- (void)fetchValueIntoObject:(id)obj
{
	if (_key != nil) {
        [obj setValue:_value forKey:_key];
    }
}

- (NSArray *)selectedIndexes
{
    NSMutableArray *selectedIndexes = [NSMutableArray arrayWithCapacity:_pickerView.numberOfComponents];
    for (int component = 0; component < _pickerView.numberOfComponents; component++) {
        [selectedIndexes addObject:[NSNumber numberWithInteger:[_pickerView selectedRowInComponent:component]]];
    }
    return selectedIndexes;
}


// Hsoi 11-Sep-2012 - added
//
// I needed a way to work with the picker's setting (current selection) as a string for JSON purposes
// (save to, restore from). Thus I created this mechanism.
//
// But one thing I noticed... when we set the items string, it's possible the _pickerView doesn't yet
// exist, thus setting may not work. So if we're in that situation, we'll just cached off the setting
// string and set all the data at that time.
- (NSString*)selectedItemsString
{
    NSMutableArray*     items = [NSMutableArray array];
    NSArray*            indexes = [self selectedIndexes];
    NSInteger           numComponents = _pickerView.numberOfComponents;
    
    for (int component = 0; component < numComponents; component++) {
        NSInteger rowIndex = [[indexes objectAtIndex:component] integerValue];
        if (rowIndex >= 0) {
            [items addObject:[_pickerView.delegate pickerView:_pickerView titleForRow:rowIndex forComponent:component]];
        }
        else {
            return nil;
        }
    }
    
    NSString* str = [items componentsJoinedByString:@","];
    return str;
}


- (void)setSelectedItemsString:(NSString *)itemsString
{
    if (_pickerView == nil) {
        self.cachedItemsString = itemsString;
    } else {
        
        // Hsoi 14-Sep-2012 - if the itemsString is nil, reset to the first item.
        //
        // Hsoi 05-Dec-2012 - If itemsString is @"", reset to -1... before the first item, to basically say
        // "we have no items selected... yet".
        
        NSArray* items = [itemsString componentsSeparatedByString:@","];
        for (NSUInteger i = 0; i < [_pickerView numberOfComponents]; i++) {
            NSString* item = nil;
            if (i < items.count) {
                item = [items objectAtIndex:i];
            }
            
            NSInteger numRows = [_pickerView numberOfRowsInComponent:i];
            NSInteger rowToSelect = 0;
            for (NSInteger x = 0; x < numRows; x++) {
                NSString* rowString = [_pickerView.delegate pickerView:_pickerView titleForRow:x forComponent:i];
                if ([item isEqualToString:rowString]) {
                    rowToSelect = x;
                    break;
                }
            }
            [_pickerView selectRow:rowToSelect inComponent:i animated:NO];
        }
        
        // Hsoi 14-Dec-2012 - now that the display's been set, ensure our internal value corresponds
        NSMutableArray *componentsValues = [NSMutableArray array];
        for (int i = 0; i < _pickerView.numberOfComponents; i++)
        {
            NSInteger rowIndex = [_pickerView selectedRowInComponent:i];
            if (rowIndex >= 0) {
                [componentsValues addObject:[_pickerView.delegate pickerView:_pickerView titleForRow:rowIndex forComponent:i]];
            } else {
                [componentsValues addObject:[NSNull null]];
            }
        }
        
        self.value = [self.valueParser objectFromComponentsValues:componentsValues];
    }
}

@end