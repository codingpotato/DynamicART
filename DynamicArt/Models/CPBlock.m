//
//  CPBlock.m
//  DynamicArt
//
//  Created by wangyw on 12-2-29.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#import "CPBlock.h"

#import "CPGeometryHelper.h"

#import "CPArgument.h"
#import "CPBlockConfiguration.h"
#import "CPBlockController.h"
#import "CPPromptArgument.h"
#import "CPStringValue.h"
#import "CPVariableManager.h"

NSString *CPBlockKeyPathFrame = @"frame";
NSString *CPBlockKeyPathPickedUp = @"pickedUp";
NSString *CPBlockKeyPathRemoved = @"removed";

static NSString *_encodingKeySyntaxOrderArguments = @"SyntaxOrderArguments";

@interface CPBlock ()

@property (strong, nonatomic) NSArray *syntaxOrderArguments;

@property (strong, nonatomic) NSArray *displayOrderArguments;

@property (weak, nonatomic) CPArgument *firstArgumentOfSecondLine;

@end

@implementation CPBlock

#pragma mark - property methods

- (void)setFrame:(CGRect)frame {
    _frame = frame;
    [self.blockController blockFrameChanged:frame];
}

/*
 * one configuration for each block class, cached in CPBlockConfiguration class
 */
- (CPBlockConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [CPBlockConfiguration configurationForBlock:self.class];
        if (!_configuration) {
            _configuration = [self createConfiguration];
            [CPBlockConfiguration setConfiguration:_configuration forBlock:self.class];
        }
    }
    return _configuration;
}

- (CPBlockConfiguration *)createConfiguration {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSArray *)syntaxOrderArguments {
    if (!_syntaxOrderArguments) {
        NSAssert1(self.configuration.syntaxArgumentClasses && self.configuration.defaultValueOfArguments && self.configuration.syntaxArgumentClasses.count == self.configuration.defaultValueOfArguments.count, @"argument count of %@ should be the same", self.configuration.blockClass);
        
        NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:self.configuration.syntaxArgumentClasses.count];
        for (NSUInteger index = 0; index < self.configuration.syntaxArgumentClasses.count; index++) {
            Class argumentClass = [self.configuration.syntaxArgumentClasses objectAtIndex:index];
            id<CPValue> defaultValue = [self.configuration.defaultValueOfArguments objectAtIndex:index];
            CPArgument *argument = [[argumentClass alloc] initWithValue:defaultValue];
            argument.parentBlock = self;
            argument.syntaxOrderIndex = index;
            [arguments addObject:argument];
        }
        _syntaxOrderArguments = [arguments copy];
    }
    return _syntaxOrderArguments;
}

- (NSArray *)displayOrderArguments {
    if (!_displayOrderArguments) {
        NSAssert(self.configuration.argumentsDescription, @"");
        
        NSArray *descriptionLines = [self.configuration.argumentsDescription componentsSeparatedByString:@"|"];
        NSAssert(descriptionLines.count <= 2, @"");
        int lineNo = 0, indexOfSencondLineFirstArgument = 0;    
        NSMutableArray *arguments = [NSMutableArray array];
        for (NSString *descriptionLine in descriptionLines) {
            NSArray *descriptions = [descriptionLine componentsSeparatedByString:@"$"];
            NSString *description = [descriptions objectAtIndex:0];
            if (![description isEqualToString:@""]) {
                CPPromptArgument *promptArgument = [[CPPromptArgument alloc] initWithString:description];
                promptArgument.parentBlock = self;
                [arguments addObject:promptArgument];
            }
            for (NSUInteger i = 1; i < descriptions.count; i++) {
                description = [descriptions objectAtIndex:i];
                NSAssert(description.length > 0, @"");
                
                NSUInteger indexOfSyntaxOrder = [description substringToIndex:1].intValue;
                NSAssert3(indexOfSyntaxOrder < self.syntaxOrderArguments.count, @"$%d in description should less than arguments count in %@ configuration: %d", (int)indexOfSyntaxOrder, self.configuration.blockClass, (int)self.syntaxOrderArguments.count);
                [arguments addObject:[self.syntaxOrderArguments objectAtIndex:indexOfSyntaxOrder]];
                NSString *promptString = [description substringFromIndex:1];
                if (![promptString isEqualToString:@""]) {
                    CPPromptArgument *promptArgument = [[CPPromptArgument alloc] initWithString:promptString];
                    promptArgument.parentBlock = self;
                    [arguments addObject:promptArgument];
                }
            }
            lineNo++;
            if (lineNo == 1) {
                indexOfSencondLineFirstArgument = (int)arguments.count;
            }
        }
        _displayOrderArguments = [arguments copy];
        if (_displayOrderArguments.count > indexOfSencondLineFirstArgument) {
            _firstArgumentOfSecondLine = [_displayOrderArguments objectAtIndex:indexOfSencondLineFirstArgument];
            if (self.configuration.numberOfSockets == 1 && self.frame.size.height == self.configuration.heightOfPlugImage + self.configuration.heightOfSocketImage) {
                [self increaseArgumentBarByHeight:self.configuration.heightOfPlugImage - self.configuration.heightOfPlugCenter];
            }
        }
    }
    return _displayOrderArguments;
}

- (BOOL)isTopBlock {
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

#pragma mark - lifecycle methods

- (id)initAtOrigin:(CGPoint)origin {
    self = [super init];
    if (self) {
        /*
         * round to interge to avoid unclear picture
         */
        origin.x = round(origin.x);
        origin.y = round(origin.y);
        _frame.origin = origin;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _syntaxOrderArguments = [aDecoder decodeObjectForKey:_encodingKeySyntaxOrderArguments];
        int index = 0;
        for (CPArgument *argument in self.syntaxOrderArguments) {
            argument.parentBlock = self;
            argument.syntaxOrderIndex = index++;
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.syntaxOrderArguments forKey:_encodingKeySyntaxOrderArguments];
}

- (void)didAddIntoBlockController {
    NSAssert(_blockController, @"");
    
    for (CPArgument *argument in self.displayOrderArguments) {
        [argument didAddIntoParentBlock];
    }
    [self arrangeArguments];
}

- (void)didFinishFrameInit {
    for (CPArgument *argument in self.syntaxOrderArguments) {
        [argument didFinishFrameInit];
    }
}

- (void)didRemoveFromBlockController {
    self.removed = YES;
    for (CPArgument *argument in self.displayOrderArguments) {
        [argument didRemoveFromParentBlock];
    }
}

#pragma mark - action methods

- (void)pickUpAllNextBlocks {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)moveAllNextBlocksByTranslation:(CGPoint)translation {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)putDownAllNextBlocks  {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)removeAllNextBlocks {
    [self doesNotRecognizeSelector:_cmd];
}

- (BOOL)connectedToOtherBlock {
    [self doesNotRecognizeSelector:_cmd];
    return NO;
}

- (void)detachFromOtherBlock {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)pickUp {
    NSAssert(!self.isPickedUp, @"block should not be picked up");
    
    self.pickedUp = YES;
    for (CPArgument *argument in self.displayOrderArguments) {
        [argument pickUpExpression];
    }
}

- (void)moveByTranslation:(CGPoint)translation {
    NSAssert(self.isPickedUp, @"block should be picked up");
    
    self.frame = CPRectTranslate(self.frame, translation);
    for (CPArgument *argument in self.displayOrderArguments) {
        [argument moveExpressionByTranslation:translation];
    }
}

- (void)putDown {
    NSAssert(self.isPickedUp, @"block should be picked up");
    
    self.pickedUp = NO;
    for (CPArgument *argument in self.displayOrderArguments) {
        [argument putDownExpression];
    }
}

- (void)remove {
    for (CPArgument *argument in self.displayOrderArguments) {
        [argument removeExpression];
    }
    [self.blockController removeOneBlockFromBlockController:self];
}

- (void)performBlockOnAllNextBlocks:(void (^) (CPBlock *))codeBlock {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)performBlock:(void (^) (CPBlock *))codeBlock {
    codeBlock(self);
    for (CPArgument *argument in self.syntaxOrderArguments) {
        [argument performBlockOnExpression:codeBlock];
    }
}

#pragma mark - argument handle methods

- (void)arrangeArguments {
    CGFloat widthOfFirstLine = 0.0;
    CGFloat x = self.configuration.leftOfFirstArgument;
    CGFloat center = self.centerOfFirstArgumentBar;
    for (CPArgument *argument in self.displayOrderArguments) {
        if (argument == self.firstArgumentOfSecondLine) {
            widthOfFirstLine = x + self.configuration.leftOfFirstArgument - self.configuration.widthBetweenTwoArguments;
            x = self.configuration.leftOfFirstArgument;
            center = self.centerOfSecondArgumentBar;
        }
        argument.origin = CGPointMake(x, center - argument.frame.size.height / 2);
        x += argument.frame.size.width + self.configuration.widthBetweenTwoArguments;
    }
    CGFloat widthOfSecondLine = x + self.configuration.leftOfFirstArgument - self.configuration.widthBetweenTwoArguments;
    self.frame = CPRectSetWidth(self.frame, widthOfFirstLine > widthOfSecondLine ? widthOfFirstLine : widthOfSecondLine);
}

- (BOOL)areArgumentsInTwoLines {
    return self.firstArgumentOfSecondLine != nil;
}

- (void)argument:(CPArgument *)sender sizeChanged:(CGSize)deltaSize {
    CGFloat maxHeight = 0.0, oldHeightOfSender = 0.0, newHeightOfSender = 0.0;
    for (CPArgument *argument in self.syntaxOrderArguments) {
        if (argument == sender) {
            newHeightOfSender = argument.frame.size.height;
            oldHeightOfSender = newHeightOfSender - deltaSize.height;
        } else if (argument.frame.size.height > maxHeight) {
            maxHeight = argument.frame.size.height;
        }
    }
    
    CGFloat deltaHeight = 0.0;
    if (newHeightOfSender > oldHeightOfSender) {
        if (maxHeight <= oldHeightOfSender) {
            deltaHeight = deltaSize.height;
        } else if (maxHeight < newHeightOfSender) {
            deltaHeight = newHeightOfSender - maxHeight;
        }
    } else if (newHeightOfSender < oldHeightOfSender) {
        if (maxHeight <= newHeightOfSender) {
            deltaHeight = deltaSize.height;
        } else if (maxHeight < oldHeightOfSender) {
            deltaHeight = maxHeight - oldHeightOfSender;
        }
    }
    if (deltaHeight) {
        [self increaseArgumentBarByHeight:deltaHeight];
    }
    if (deltaSize.width) {
        [self increaseWidthBy:deltaSize.width];
    }
    [self arrangeArguments];
}

- (CPArgument *)argumentConnectedTo:(CPExpression *)expression {
    CPArgument *nearArgument = nil;
    for (CPArgument *argument in self.displayOrderArguments) {
        nearArgument = [argument argumentNearToExpression:expression];
        if (nearArgument) {
            break;
        }
    }
    return nearArgument;
}

- (void)stickAllExpressions {
    for (CPArgument *argument in self.displayOrderArguments) {
        [argument stickExpression];
    }
}

- (void)increaseWidthBy:(CGFloat)deltaWidth {
    self.frame = CPRectIncreaseWidth(self.frame, deltaWidth);
}

- (CGFloat)centerOfFirstArgumentBar {
    [self doesNotRecognizeSelector:_cmd];
    return 0.0;
}

- (CGFloat)centerOfSecondArgumentBar {
    [self doesNotRecognizeSelector:_cmd];
    return 0.0;
}

- (void)increaseArgumentBarByHeight:(CGFloat)deltaHeight {
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - export methods
                                     
- (void)exportAllNextBlockToString:(NSMutableString *)string level:(NSUInteger)level {
    [self doesNotRecognizeSelector:_cmd];
}

- (void)exportFirstArgumentLineToString:(NSMutableString *)string level:(NSUInteger)level {
    for (CPArgument *argument in self.displayOrderArguments) {
        if (argument == self.firstArgumentOfSecondLine) {
            break;
        }
        [argument exportToString:string];
    }
}

- (void)exportSecondArgumentLineToString:(NSMutableString *)string level:(NSUInteger)level {
    BOOL foundFirstArgumentOfSecondLine = NO;
    for (CPArgument *argument in self.displayOrderArguments) {
        if (argument == self.firstArgumentOfSecondLine) {
            foundFirstArgumentOfSecondLine = YES;
        }
        if (foundFirstArgumentOfSecondLine) {
            for (int i = 0; i < level; i++) {
                [string appendString:@"    "];
            }
            [argument exportToString:string];
        }
    }
}

- (void)exportToString:(NSMutableString *)string level:(NSUInteger)level {
    [self exportFirstArgumentLineToString:string level:level];
}

@end
