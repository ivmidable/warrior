#[allow(unused_use)]
module warrior::hodl_tests {
    use sui::test_scenario as ts; 
    use sui::tx_context::TxContext; 
    use sui::kiosk::{Kiosk, KioskOwnerCap, Self}; 
    use sui::transfer; 
    use warrior::hodl::{
        add, 
        add_item, 
        remove_item
    }; 
    
    const OWNER: address = @0x11; 
    const ALICE: address = @0xAA; 
    
    
    // Add Kiosk Extension to Personal Kiosk 
    #[test]
    #[expected_failure]
    fun add_extension_verify_test() :  ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            let (kiosk, cap) = kiosk::new(ts::ctx(scenario)); 
            ts::next_tx(scenario, OWNER); 

            ts::next_tx(scenario, OWNER); 
            add(
                &cap, 
                &mut kiosk, 
                ts::ctx(scenario)
            );

            ts::next_tx(scenario, OWNER); 
            transfer::public_transfer(kiosk, ALICE); 
            transfer::public_transfer(cap, ALICE);
        }; 
        scenario_val
    }

    #[test]

}