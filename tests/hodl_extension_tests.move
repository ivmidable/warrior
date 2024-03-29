#[allow(unused_use)]
module warrior::hodl_tests {
    use sui::test_scenario as ts; 
    use sui::tx_context::TxContext; 
    use sui::kiosk::{Kiosk, KioskOwnerCap, Self}; 
    use sui::transfer; 
    use kiosk::personal_kiosk; 
    use warrior::hodl::{
        add, 
        add_item, 
        remove_item, 
        get_hodl_count
    }; 
    
    const OWNER: address = @0x11; 
    const ALICE: address = @0xAA; 
 
    
    // Add Kiosk Extension to Personal Kiosk 
    #[test]
    fun add_extension_verify_test() :  ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            let (kiosk, cap) = kiosk::new(ts::ctx(scenario)); 
            //let pk_cap = personal_kiosk::new(&mut kiosk, cap, ts::ctx(scenario));

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

    // Add Item To Kiosk 
    #[test]
    fun add_item_test() : ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            let (kiosk, cap) = kiosk::new(ts::ctx(scenario)); 
            //let pk_cap = personal_kiosk::new(&mut kiosk, cap, ts::ctx(scenario));

            ts::next_tx(scenario, OWNER); 
            add(
                &cap, 
                &mut kiosk, 
                ts::ctx(scenario)
            );

            ts::next_tx(scenario, OWNER); 
            add_item(
                &mut kiosk, 
                2
            ); 

            ts::next_tx(scenario, OWNER);     

            transfer::public_transfer(kiosk, ALICE); 
            transfer::public_transfer(cap, ALICE);
        }; 
        scenario_val
    }

    // Add and remove item from kiosk 
    #[test]
    fun remove_item_test() : ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            let (kiosk, cap) = kiosk::new(ts::ctx(scenario)); 
            //let pk_cap = personal_kiosk::new(&mut kiosk, cap, ts::ctx(scenario));

            ts::next_tx(scenario, OWNER); 
            add(
                &cap, 
                &mut kiosk, 
                ts::ctx(scenario)
            );

            ts::next_tx(scenario, OWNER); 
            add_item(
                &mut kiosk, 
                2
            ); 

            ts::next_tx(scenario, OWNER);   
            remove_item(
                &mut kiosk, 
                2
            ); 

            ts::next_tx(scenario, OWNER);   

            transfer::public_transfer(kiosk, ALICE); 
            transfer::public_transfer(cap, ALICE);
        }; 
        scenario_val
    }

    #[test]
    fun hodl_count_test() : ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            let (kiosk, cap) = kiosk::new(ts::ctx(scenario)); 
            //let pk_cap = personal_kiosk::new(&mut kiosk, cap, ts::ctx(scenario));

            ts::next_tx(scenario, OWNER); 
            add(
                &cap, 
                &mut kiosk, 
                ts::ctx(scenario)
            );

            ts::next_tx(scenario, OWNER); 
            add_item(
                &mut kiosk, 
                2
            ); 

            ts::next_tx(scenario, OWNER); 
            get_hodl_count(
                &mut kiosk, 
                2
            );     

            transfer::public_transfer(kiosk, ALICE); 
            transfer::public_transfer(cap, ALICE);
        }; 
        scenario_val
    }

}