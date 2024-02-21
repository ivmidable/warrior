module warrior::warrior {
    use std::string::String;
    use std::vector;

    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self,UID, ID};
    use sui::bag::{Self, Bag};
    use sui::vec_map::{Self, VecMap};
    
    use sui::dynamic_field as df;
    use warrior::warrior_nft::{Self, Warrior_nft};

    const ENotEnoughPiecesToComplete:u64 = 0;

    struct WarriorCap has key {}

    struct WarriorConfig has key, store {
        pieces_to_complete:u8
    }

    struct WarriorAccount has key, store {
        warriors: VecMap<u8, ID>
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(WarriorCap {}, tx_context::sender(ctx))
    }

    fun new(&WarriorCap, pieces_to_complete:u8, ctx: &TxContext) {
        transfer::share_object(WarriorConfig { pieces_to_complete })
    }

    public fun create_warriors(ctx: &TxContext) : WarriorAccount {
        transfer::transfer(WarriorAccount {
            warriors: vec_map::empty()
        }, tx_context::sender(ctx))
    }

    public fun add_warriors(warriors: &mut WarriorAccount, warrior_nft:&Warrior_nft) {
        vec_map::insert(warriors,  warrior_nft::get_piece(warrior_nft), object::id(warrior_nft))
    }

    public fun complete_puzzle(config: &WarriorConfig, warriors: &WarriorAccount, ctx: &TxContext) {
        assert!(vec_map::size(warriors) == config.pieces_to_complete, ENotEnoughPiecesToComplete);
    }
}

Warrior Project

Kiosk
24 puzzle pieces = 1 NFT
Bid one hour a day for 24 days
Max 100 per day
Available on secondary Market
First to collect all 24 and put full NFT together wins-Function to receive first full token in wallet
24 pieces = complete
Complete = claim
Claim first = winner
Winner = payout

Payout is half revenue
Other half goes to charity
Monthly NFT Auction

Puzzle pieces can be numbered - need 1-24 and submit first

Highest bid equals zero
If new bid is greater than highest bid
New bid equals highest bid
Or we can have it as one auction per 10 minutes with five per hour and blacklist any winner of previous option
Four winners/ hour 96 per day

Lunar Sports
Combine score call

Pick your team 1:1

If winner = true payout
Else O

Or matching