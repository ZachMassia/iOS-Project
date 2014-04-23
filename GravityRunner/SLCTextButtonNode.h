//
//  SLCTextButtonNode.h
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-23.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCButtonNode.h"

/**
 *  An SLCButtonNode with text support.
 */
@interface SLCTextButtonNode : SLCButtonNode

/**
 *  Initialize a button and scale the texture.
 *
 *  @param name The texture name.
 *  @param size The size to scale the texture to.
 *  @param text The text to display on the button.
 *
 *  @return The button node.
 */
- (id)initWithImageNamed:(NSString *)name size:(CGSize)size text:(NSString *)text;

@end
