module warrior::warrior_nft {
    use std::string::String;
    use sui::transfer;
    //use sui::url::{Self, Url};
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID, ID};
    use sui::borrow::{Self, Referent};
    use sui::package;
    use sui::transfer_policy::{Self as tpol, TransferPolicy};
    use sui::clock::{Self, Clock};
    use kiosk::{royalty_rule, floor_price_rule, kiosk_lock_rule, personal_kiosk_rule};
    //use warrior::hodl_rule;
    use std::vector;

    // minting_kiosk doesn't yet exist in this package
    //friend warrior::minting_kiosk;

    //One time witness is only instantiated in the init method
    struct WARRIOR_NFT has drop {}

    struct WarriorRound has key, store {
        id: UID,
        mint_cap:ID,
        supply:u64,
        base_price:u64,
        puzzle_rounds: vector<PuzzleRound>,
        started_at:u64,
        ends_at:u64
    }

    struct MintCap has key, store {
        id: UID,
        tpol: Referent<TransferPolicy<WarriorNft>>
    }

    struct PuzzleRound has store, copy, drop {
        warrior_round:ID,
        puzzle_round:u8,
        name: String,
        image_uri: String,
        json_uri: String,
        ends_at:u64,
    }

    //One time witness is only instantiated in the init method
    //struct WARRIOR_NFT has drop {}

    struct WarriorNft has key, store {
        id: UID, //UID for Sui Global Store
        warrior_round:u64, //which warrior round this belongs to.
        puzzle_round:u8, //Puzzle piece number
        name: String,
        image_uri: String,
        json_uri: String
    }

    #[lint_allow(share_owned, self_transfer)]
    fun init(otw: WARRIOR_NFT, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        // // Init Publisher
        let publisher = package::claim(otw, ctx);

        //Transfer Policy creation and rules for the MintCap
        let (tp_mint, tp_mint_cap) = tpol::new<WarriorNft>(&publisher, ctx);
        royalty_rule::add(&mut tp_mint, &tp_mint_cap, 300, 0);
        //add 

        //Create mint cap and wrap transfer policy with a Referent.
        let mint_cap = MintCap {
            id: object::new(ctx),
            tpol: borrow::new(tp_mint, ctx)
        };

        //Transfer Policy creation and rules for the user kiosk.
        let (tp_user, tp_user_cap) = tpol::new<WarriorNft>(&publisher, ctx);
        royalty_rule::add(&mut tp_user, &tp_user_cap, 300, 0);
        floor_price_rule::add(&mut tp_user, &tp_user_cap, 1000000000);
        kiosk_lock_rule::add(&mut tp_user, &tp_user_cap);
        personal_kiosk_rule::add(&mut tp_user, &tp_user_cap);
        //hodl

        transfer::public_transfer(mint_cap, sender);
        transfer::public_transfer(publisher, sender);
        transfer::public_transfer(tp_user, sender);
        transfer::public_transfer(tp_user_cap, sender);
        transfer::public_transfer(tp_mint_cap, sender);
    }

    public(friend) fun new_warrior_round(m_cap:&MintCap, clock:&Clock,  ctx: &mut TxContext, base_price:u64, length:u64) : WarriorRound {
        let warrior_round = WarriorRound {
            id: object::new(ctx),
            mint_cap: object::id(m_cap),
            supply:0,
            base_price,
            puzzle_rounds: vector::empty(),
            started_at: clock::timestamp_ms(clock),
            ends_at: clock::timestamp_ms(clock) + length
        };
        warrior_round
        
    }

    public fun add_puzzle_round(_:&MintCap, warrior_round:&mut WarriorRound, name:String, image_uri:String, json_uri:String, ends_at:u64 ) {
        let len = (vector::length(&warrior_round.puzzle_rounds) as u8);
        let id = object::id(warrior_round);
        vector::push_back(&mut warrior_round.puzzle_rounds, PuzzleRound { 
            warrior_round: id, 
            puzzle_round: len,
            name,
            image_uri,
            json_uri,
            ends_at
        })
    }

    public(friend) fun create_nft(
        _: &MintCap,
        name: String,
        warrior_round:u64,
        puzzle_round:u8,
        image_uri: String,
        json_uri: String,
        ctx: &mut TxContext,
    ) : WarriorNft {
        let nft = WarriorNft {
            id: object::new(ctx),
            name,
            warrior_round,
            puzzle_round,
            image_uri,
            json_uri
        };

        //mint_cap::increment_supply(mint_cap, 1);
        // mint_event::emit_mint(
        //     witness::from_witness(Witness {}),
        //     mint_cap::collection_id(mint_cap),
        //     &nft,
        // );

        nft
    }

    //transfer NFT
    public fun transfer(nft: WarriorNft, recipient: address) {
        transfer::transfer(nft, recipient)
    }

    //burn NFT 
    public fun destroy(nft: WarriorNft) {
        let WarriorNft { id, name: _, warrior_round: _, puzzle_round: _, image_uri: _, json_uri: _ } = nft; 
        object::delete(id); 
    }

    // Getters Warrior NFT 
    public fun warrior_round(nft: &WarriorNft): &u64 {
        &nft.warrior_round
    }

    public fun puzzle_round(nft: &WarriorNft): &u8 {
        &nft.puzzle_round
    }
    
    public fun name(nft: &WarriorNft): &String {
        &nft.name
    }

    public fun image_uri(nft: &WarriorNft): &String {
        &nft.image_uri
    }

    public fun json_uri(nft: &WarriorNft): &String {
        &nft.json_uri
    }

    #[test_only]
    // Wrapper of module initializer for testing
    public fun init_for_test(ctx: &mut TxContext) {
        init(WARRIOR_NFT {}, ctx); 
    }

    #[test_only]
    use sui::test_scenario as ts; 
    #[test_only]
    use sui::address;

    #[test]
    fun init_test() : ts::Scenario {
        let sender_address = address::from_u256(100); 
        let scenario_val = ts::begin(sender_address); 
        let scenario = &mut scenario_val; 
        {
            init_for_test(ts::ctx(scenario)); 
        }; 
        scenario_val
    }
}