#[allow(unused_use)]
module warrior::warrior {
    use std::string::String;
    use std::vector;

    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self ,UID, ID};
    use sui::bag::{Self, Bag};
    use sui::vec_map::{Self, VecMap};
    use sui::transfer;
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::kiosk_extension;
    use kiosk::{personal_kiosk, royalty_rule, kiosk_lock_rule, witness_rule};
    
    use sui::dynamic_field as df;
    use warrior::warrior_nft::{Self, WarriorNft};

    // const ENotEnoughPiecesToComplete:u64 = 0;
    // const EMaxNumberOfWinnersReached:u64 = 1;

    // //Capability representing the owner of Warrior Config.
    // struct WarriorConfigCap has key {id:UID}

    // //Capability representing the owner of a WarriorAccount
    // struct WarriorOwnerCap has key {id:UID}

    // struct WarriorExtension has drop {}


    // struct WarriorConfig has key, store {
    //     id:UID,
    //     to_complete:u8,
    //     max_winners:u8,
    //     claimed:u8, //how many people have completed the puzzle
    // }

    // struct WarriorMintAccount has store, drop {
    //     config_id:ID,
    //     warriors: vector<ID>
    // }

    // struct WarriorAccount has store, drop {
    //     config_id:ID,
    //     warriors: VecMap<u8, ID>
    // }

    // fun init(ctx: &mut TxContext) {
    //     transfer::transfer(WarriorConfigCap {id:object::new(ctx)}, tx_context::sender(ctx))
    // }

    // public fun new(_:&WarriorConfigCap, to_complete:u8, max_winners:u8, ctx: &mut TxContext) {
    //     transfer::share_object(WarriorConfig {
    //         id:object::new(ctx),
    //         to_complete,
    //         max_winners,
    //         claimed:0
    //     })
    // }

    // // public fun create_warriors(_ctx: &TxContext) : WarriorAccount {
    // //     // transfer::transfer(WarriorAccount {
    // //     //     warriors: vec_map::empty()
    // //     // }, tx_context::sender(ctx))
    // //     WarriorAccount {
    // //         warriors: vec_map::empty()
    // //     }
    // // }

    // fun add_warriors(warriors: &mut WarriorAccount, warrior_nft: &WarriorNft) {
    //     vec_map::insert(&mut warriors.warriors,  warrior_nft::get_type(warrior_nft), object::id(warrior_nft))
    // }

    // public fun complete_puzzle(config: &mut WarriorConfig, warriors: &WarriorAccount, _ctx: &TxContext) {
    //     assert!(vec_map::size(&warriors.warriors) == (config.to_complete as u64), ENotEnoughPiecesToComplete);
    //     //assert!(config.claimed == config.max_number_of_winners, EMaxNumberOfWinnersReached);
    //     if (config.claimed == config.max_winners) {
    //         //mint puzzle participation price 
    //         //return
    //     }

    //     //60:30:10 - out of 50%
        
    // }

    //create a new personal kiosk, 

    //add warrior extension to Kiosk
    // public fun add(
    //     cap: &KioskOwnerCap,
    //     kiosk: &mut Kiosk,
    //     ctx: &mut TxContext
    //  ) {

    //     let ext = WarriorExtension {};
    //     kiosk_extension::add<WarriorExtension>(ext, kiosk, cap, 3, ctx)
    //  }

    //add warrior piece to extension.
    // public fun add(
    //     cap: &KioskOwnerCap,
    //     config: &WarriorConfig,
    //     kiosk: &mut Kiosk,
    //     ctx: &mut TxContext
    //  ) {
    //     let ext = WarriorAccount {
    //         config_id: object::id(config),
    //         warriors: vec_map::empty()
    //     };
    //     kiosk_extension::add<WarriorAccount>(ext, kiosk, cap, 3, ctx)
    //  }

    //  public fun buy_nft<WarriorNft>(
    //     kiosk: &mut Kiosk,
    //     nft: WarriorNft
    //  ) {
    //     let ext = WarriorExtension {};
    //     let bag = kiosk_extension::storage_mut<WarriorExtension>(ext, kiosk);
    //     //kiosk_extension::storage_mut<WarriorExtension>(ext, kiosk)
    //  }

    //  public fun bid_for_warrior_piece() {}

}


//Warrior NFT - NFt contract representing the pieces

//Front end - Juan

//Warrior Extension - Richard
//Warrior Extension - is the ruleset for controling how many Pieces they can have in a Kiosk

// Tranasfer Policy - 
//For Kiosk we need a transfer policy to determine royalty, 50:50 split on trade. after 25th day determine where 100%
// -- All royalties from trading go to charity or dao treasury.

//Fee Policy - Berg
//Incrementing Fee - Take fixed_fee policy for venue and increment based on a number of Pieces sold at primary market
//  -- do 50:50 split on purchase. price pool and charity pool
//  after 25th day 