#[allow(unused_use)]
module warrior::hodl_rule_tests {
    use sui::test_scenario as ts; 
    use sui::tx_context::TxContext;
    use sui::kiosk::{Kiosk, KioskOwnerCap, Self};  
    use sui::transfer_policy_tests as test; 
    use sui::transfer_policy as policy; 
    use sui::transfer; 

    use warrior::hodl_rule::{
        add_policy, 
        prove
    }; 

    use warrior::hodl::{
        add, 
        add_item, 
    };

    const OWNER: address = @0x11;
    const ALICE: address = @0xAA; 
    const BOB: address = @0xBB; 

    #[test]
    fun add_test() : ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            let (policy, tcap) = test::prepare(ts::ctx(scenario)); 
            add_policy(
                &mut policy, 
                &tcap, 
                1
            ); 
            ts::next_tx(scenario, OWNER); 
            transfer::public_transfer(policy, OWNER); 
            transfer::public_transfer(tcap, OWNER); 
        }; 
        scenario_val
    }

    #[test]
    fun prove_test_pass() : ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            // Transfer Policy 
            let (policy, tcap) = test::prepare(ts::ctx(scenario)); 
            add_policy(
                &mut policy, 
                &tcap, 
                1
            ); 

            let (buyer_kiosk, buyer_cap) = kiosk::new(ts::ctx(scenario)); 
            let (seller_kiosk, seller_cap) = kiosk::new(ts::ctx(scenario));
            
            // Add Extension to Kiosks
            ts::next_tx(scenario, OWNER);
            add(
                &buyer_cap, 
                &mut buyer_kiosk, 
                ts::ctx(scenario)
            ); 

            ts::next_tx(scenario, OWNER); 
            add(
                &seller_cap, 
                &mut seller_kiosk, 
                ts::ctx(scenario)
            ); 

            // Add Item to Bob's Kiosk for sale 
            ts::next_tx(scenario, BOB); 
            add_item(
                &mut seller_kiosk, 
                2
            );

            let request = policy::new_request(
                test::fresh_id(ts::ctx(scenario)), 
                1000, 
                test::fresh_id(ts::ctx(scenario))
            ); 

            ts::next_tx(scenario, OWNER); 
            prove(
                &mut seller_kiosk, 
                &mut buyer_kiosk, 
                2, 
                &mut policy, 
                &mut request, 
                ts::ctx(scenario)
            ); 

            // Let ALICE = buyer and BOB = seller, transfer Kiosks
            ts::next_tx(scenario, OWNER); 
            transfer::public_transfer(buyer_kiosk, ALICE); 
            transfer::public_transfer(buyer_cap, ALICE); 

            ts::next_tx(scenario, OWNER); 
            transfer::public_transfer(seller_kiosk, BOB); 
            transfer::public_transfer(seller_cap, BOB); 

            // Consume Policy And Request 
            policy::confirm_request(&mut policy, request);
            test::wrapup(policy, tcap, ts::ctx(scenario)); 

        }; 
        scenario_val
    }

}