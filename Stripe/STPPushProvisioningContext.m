//
//  STPPushProvisioningContext.m
//  Stripe
//
//  Created by Jack Flintermann on 9/27/18.
//  Copyright © 2018 Stripe, Inc. All rights reserved.
//

#import "STPPushProvisioningContext.h"
#import "STPEphemeralKeyManager.h"
#import "STPAPIClient+Private.h"
#import "STPAPIClient+PushProvisioning.m"
#import "STPEphemeralKey.h"

@interface STPPushProvisioningContext()
@property (nonatomic, strong) STPEphemeralKeyManager *keyManager;
@property (nonatomic, strong, nullable) STPEphemeralKey *ephemeralKey;
@end

@implementation STPPushProvisioningContext

- (instancetype)initWithKeyProvider:(id<STPIssuingCardEphemeralKeyProvider>)keyProvider {
    self = [super init];
    if (self) {
        _keyManager = [[STPEphemeralKeyManager alloc] initWithKeyProvider:keyProvider apiVersion:[STPAPIClient apiVersion] performsEagerFetching:NO];
    }
    return self;
}

- (void)generateRequestConfiguration:(nullable STPPushProvisioningRequestConfigurationBlock)completion {
        
        //        stpDispatchToMainThreadIfNecessary(^{
        //            completion(self.customer, nil);
        //        });
}

- (void)_generateRequestConfiguration:(STPPushProvisioningRequestConfigurationBlock)completion {
    [self.keyManager getOrCreateKey:^(STPEphemeralKey * _Nullable ephemeralKey, NSError * _Nullable keyError) {
        if (keyError != nil) {
            completion(nil, keyError);
            return;
        }
        
        STPAPIClient *client = [STPAPIClient apiClientWithEphemeralKey:ephemeralKey];
        [client retrieveIssuingCardWithID:ephemeralKey.issuingCardID completion:^(STPIssuingCard * _Nullable card, NSError * _Nullable cardError) {
            if (cardError != nil) {
                completion(nil, cardError);
                return;
            }
            
            if (![[PKPassLibrary new] canAddPaymentPassWithPrimaryAccountIdentifier:card.cardId]) {
                NSError *error = nil; // TODO
                completion(nil, error);
            }
            
            PKAddPaymentPassRequestConfiguration *configuration = [[PKAddPaymentPassRequestConfiguration alloc] initWithEncryptionScheme:PKEncryptionSchemeECC_V2];
            configuration.cardholderName = card.name;
            configuration.primaryAccountSuffix = card.last4;
            if (@available(iOS 12.0, *)) {
                configuration.style = PKAddPaymentPassStylePayment;
            }
            configuration.paymentNetwork = [STPCard stringFromBrand:card.brand];
            completion(configuration, nil);
        }];
    }];
}

- (void)addPaymentPassViewController:(nonnull PKAddPaymentPassViewController *)controller generateRequestWithCertificateChain:(nonnull NSArray<NSData *> *)certificates nonce:(nonnull NSData *)nonce nonceSignature:(nonnull NSData *)nonceSignature completionHandler:(nonnull void (^)(PKAddPaymentPassRequest * _Nonnull))handler {
    [self.keyManager getOrCreateKey:^(STPEphemeralKey * _Nullable ephemeralKey, NSError * _Nullable keyError) {
        if (keyError != nil) {
            handler([PKAddPaymentPassRequest new]);
            return;
        }
        STPPushProvisioningDetailsParams *params = [STPPushProvisioningDetailsParams paramsWithCardId:ephemeralKey.issuingCardID certificates:certificates nonce:nonce nonceSignature:nonceSignature];
        STPAPIClient *client = [STPAPIClient apiClientWithEphemeralKey:ephemeralKey];
        [client retrievePushProvisioningDetailsWithParams:params completion:^(STPPushProvisioningDetails * _Nullable details, NSError * _Nullable error) {
            if (error != nil) {
                handler([PKAddPaymentPassRequest new]);
                return;
            }
            PKAddPaymentPassRequest *request = [[PKAddPaymentPassRequest alloc] init];
            request.activationData = details.activationData;
            request.encryptedPassData = details.encryptedPassData;
            request.ephemeralPublicKey = details.ephemeralPublicKey;
            handler(request);
        }];
    }];
}

- (void)addPaymentPassViewController:(nonnull PKAddPaymentPassViewController *)controller didFinishAddingPaymentPass:(nullable PKPaymentPass *)pass error:(nullable NSError *)error { 
    <#code#>
}


@end
