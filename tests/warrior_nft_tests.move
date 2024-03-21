module warrior::warrior_nft_tests {
    use sui::test_scenario as ts; 
    use warrior::warrior_nft::{
        init_for_test, 
        create_nft, 
        WarriorNft,
        MintCap, 
        transfer, 
        destroy
    };

    use std::string::{Self};

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
    fun mint_test() : ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            init_for_test(ts::ctx(scenario)); 
            ts::next_tx(scenario, OWNER); 

            let mint_cap = ts::take_from_address<MintCap>(scenario, OWNER);

            let nft = create_nft(
                &mint_cap,
                string::utf8(b"TestWarrior"),
                1,
                2,
                string::utf8(b"example.com/warrior.png"),
                string::utf8(b"example.com/warrior.json"),
                ts::ctx(scenario)
            );

            ts::return_to_address<MintCap>(OWNER, mint_cap); 
            
            ts::next_tx(scenario, OWNER); 
            transfer(nft, ALICE); 
        }; 
        scenario_val
    }

    #[test]
    fun burn_test() : ts::Scenario {
        let scenario_val = ts::begin(OWNER); 
        let scenario = &mut scenario_val; 
        {
            init_for_test(ts::ctx(scenario)); 
            ts::next_tx(scenario, OWNER); 

            let mint_cap = ts::take_from_address<MintCap>(scenario, OWNER);

            let nft = create_nft(
                &mint_cap,
                string::utf8(b"TestWarrior"),
                1,
                2,
                string::utf8(b"example.com/warrior.png"),
                string::utf8(b"example.com/warrior.json"),
                ts::ctx(scenario)
            );

            ts::return_to_address<MintCap>(OWNER, mint_cap); 
            
            ts::next_tx(scenario, OWNER); 
            destroy(nft); 
        }; 
        scenario_val
    }
}