#[allow(unused_use)]
module warrior::hodl_rule_tests {
    use sui::test_scenario as ts; 
    use sui::tx_context::TxContext; 
    use sui::transfer_policy::{
        TransferPolicy, 
        TransferPolicyCap, 
        TransferRequest
    }; 

    const OWNER: address = @0x11; 
}