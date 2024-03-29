//don't allow a user to hold more than a specified amount of puzzle pieces
//in thier wallet
module warrior::hodl_rule {
    use sui::transfer_policy::{
        Self as policy,
        TransferPolicy,
        TransferPolicyCap,
        TransferRequest
    };

    use sui::tx_context::{TxContext};

    use sui::kiosk::{Kiosk};
    //use std::string::String;

    use warrior::hodl;
    //use warrior::warrior_nft;

    /// Can't exceed the hodl limit.
    const EHodlLimitReached: u64 = 0;
    const EHodlInvalidSetup: u64 = 1;

    /// The "Rule" witness to authorize the policy.
    struct Rule has drop {}

    /// Configuration for the `Hodl Count Rule`.
    /// It holds the maximum number of puzzles that a Kiosk can hold.
    struct Config has store, drop {
        hodl_count: u64
    }

    /// Creator action: Add the Hodl Rule for the `T`.
    /// Pass in the `TransferPolicy`, `TransferPolicyCap` and `hodl_count`.
    public fun add_policy<T>(
        policy: &mut TransferPolicy<T>,
        cap: &TransferPolicyCap<T>,
        hodl_count: u64
    ) {
        policy::add_rule(Rule {}, policy, cap, Config { hodl_count })
    }

    /// Buyer action: Prove that the hodl count has not already been reached.
    public fun prove<T>(
        seller_kiosk: &mut Kiosk,
        buyer_kiosk: &mut Kiosk,
        key:u64,
        policy: &mut TransferPolicy<T>,
        request: &mut TransferRequest<T>, 
        ctx: &mut TxContext,
    ) {
        let config: &Config = policy::get_rule(Rule {}, policy);

        //Assert that hodl extension is installed and enabled.
        assert!(hodl::is_setup(seller_kiosk, ctx), EHodlInvalidSetup);
        assert!(hodl::is_setup(buyer_kiosk, ctx), EHodlInvalidSetup);

        //check to see if buyers hodl count is less than the config.
        assert!(hodl::get_hodl_count(buyer_kiosk, key) < config.hodl_count, EHodlLimitReached);

        //update hodl counts for each kiosk.
        hodl::add_item(buyer_kiosk, key);
        hodl::remove_item(seller_kiosk, key);

        //add receipt to policy.
        policy::add_receipt(Rule {}, request)
    }
}
