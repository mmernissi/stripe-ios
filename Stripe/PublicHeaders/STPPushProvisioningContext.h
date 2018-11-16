//
//  STPPushProvisioningContext.h
//  Stripe
//
//  Created by Jack Flintermann on 9/27/18.
//  Copyright © 2018 Stripe, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPEphemeralKeyProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface STPPushProvisioningContext : NSObject

- (instancetype)initWithKeyProvider:(id<STPEphemeralKeyProvider>)keyProvider;

@end

NS_ASSUME_NONNULL_END
