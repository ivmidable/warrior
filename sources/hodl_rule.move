//don't allow a user to hold more than a specified amount of puzzle pieces
//in thier wallet
module warrior::hodl_rule {
    use sui::transfer_policy::{
        Self as policy,
        TransferPolicy,
        TransferPolicyCap,
        TransferRequest
    };

    /// The price was lower than the floor price.
    const EHodlLimitReached: u64 = 0;

    /// The "Rule" witness to authorize the policy.
    struct Rule has drop {}

    /// Configuration for the `Floor Price Rule`.
    /// It holds the minimum price that an item can be sold at.
    /// There can't be any sales with a price < than the floor_price.
    struct Config has store, drop {
        hodl_count: u64
    }

    /// Creator action: Add the Floor Price Rule for the `T`.
    /// Pass in the `TransferPolicy`, `TransferPolicyCap` and `floor_price`.
    public fun add<T>(
        policy: &mut TransferPolicy<T>,
        cap: &TransferPolicyCap<T>,
        hodl_count: u64
    ) {
        policy::add_rule(Rule {}, policy, cap, Config { hodl_count })
    }

    /// Buyer action: Prove that the amount is higher or equal to the floor_price.
    public fun prove<T>(
        policy: &mut TransferPolicy<T>,
        request: &mut TransferRequest<T>
    ) {
        let config: &Config = policy::get_rule(Rule {}, policy);

        // 1. Assert that hodl extension is installed and enabled.

        // 2. Load hodl extension bad and check counter to see how many pieces are present.
        // if the newly incremented amount is greater than allowance throw error.

        //assert!(policy::paid(request) >= config.floor_price, EPriceTooSmall);

        policy::add_receipt(Rule {}, request)
    }
}
