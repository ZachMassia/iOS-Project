//
//  SLCTextButtonNode.m
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-23.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCTextButtonNode.h"

@interface SLCTextButtonNode()

/**
 *  The button text.
 */
@property (strong, nonatomic) SKLabelNode *label;

@end

@implementation SLCTextButtonNode

- (id)initWithImageNamed:(NSString *)name size:(CGSize)size text:(NSString *)text {
    if (self = [super initWithImageNamed:name size:size]) {
        self.label.text = text;
        self.label.position = CGPointMake(CGRectGetMidX(self.texture.frame),
                                          CGRectGetMidY(self.texture.frame) - (self.label.frame.size.height / 2));
    }
    return self;
}

- (SKLabelNode *)label {
    if (!_label) {
        _label = [SKLabelNode labelNodeWithFontNamed:@"KenPixel Blocks"];
        _label.fontSize = self.texture.size.height / 2;
        _label.fontColor = [SKColor blackColor];
        _label.zPosition = 10;

        [self addChild:_label];
    }
    return _label;
}

@end
