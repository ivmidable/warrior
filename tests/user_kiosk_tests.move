module warrior::user_kiosk_tests {
    use sui::test_scenario as ts; 
    use sui::transfer; 
    
    use warrior::user_kiosk::{
        init_for_test, 
        create_user_kiosk,
        Registry
    }; 

    const OWNER: address = @0x11;
    const ALICE: address = @0xAA; 

    #[test]
    fun init_test() : ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            init_for_test(ts::ctx(scenario)); 
        }; 
        scenario_val
    }

    #[test]
    fun init_and_user_kiosk_test() : ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            init_for_test(ts::ctx(scenario)); 
            ts::next_tx(scenario, OWNER); 

            let registry = ts::take_shared<Registry>(scenario); 

            let kiosk = create_user_kiosk(
                &mut registry, 
                ts::ctx(scenario)
            );

            ts::return_shared<Registry>(registry); 

            ts::next_tx(scenario, OWNER); 
            transfer::public_transfer(kiosk, ALICE); 
        }; 

        scenario_val
    }

}