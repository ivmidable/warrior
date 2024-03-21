module warrior::warrior_nft_tests {
    use sui::test_scenario as ts; 
    use warrior::warrior_nft::{
        init_for_test, 
        create_nft
    };

    use std::string::{Self};

    const OWNER: address = @0x11;
    
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
    fun mint_test() : ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            init_for_test(ts::ctx(scenario)); 
            ts::next_tx(scenario, OWNER); 

            let mint_cap = 

            let nft = create_nft(
                mint_cap,
                string::utf8(b"TestWarrior"),
                1,
                2,
                string::utf8(b"example.com/warrior.png"),
                string::utf8(b"example.com/warrior.json"),
                ts::ctx(scenario)
            );
            
        }; 
        scenario_val
    }
}