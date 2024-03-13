module warrior::warrior_nft {
    use std::string::{Self, String};

    use sui::transfer;
    use sui::url::{Self, Url};
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID, ID};
    use sui::package;
    use sui::transfer_policy;
    use sui::clock::{Self, Clock};

    use std::vector;

    friend warrior::minting_kiosk;

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
    }

    //Wrapper transferpolicy for minting.
    struct MintPolicy has key, store {
        id:UID,
       // policy: TransferPolicy<WarriorNft>,
    }

    struct PuzzleRound has store, copy, drop {
        warrior_round:ID,
        puzzle_round:u8,
        name: String,
        image_uri: String,
        json_uri: String,
    }

    struct Puzzle has store, drop {
        name: String,
        image_uri: String,
        json_uri: String
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

        // let mint_cap = MintCap {
        //     id: object::new(ctx)
        // };

        // // Init Publisher
        // let publisher = package::claim(otw, ctx);

        //Create TransferPolicy for Warrior NFt
        // let (tp_mint, tp_mint_cap) = transfer_policy::new<WarriorNft>(&publisher, ctx);
        // let (tp_user, tp_user_cap) = transfer_policy::new<WarriorNft>(&publisher, ctx);
        // let m_policy = MintPolicy {
        //     id: object::new(ctx),
        //     //policy: tp_user
        // };

        //transfer::public_transfer(mint_cap, sender)
        //transfer::public_transfer(publisher, sender);
        //transfer::public_transfer(m_policy, sender);
        //transfer::public_transfer(tp_user, sender);
        //transfer::public_transfer(tp_user_cap, sender);
        //transfer::public_transfer(tp_mint_cap, sender);
        //transfer::public_share_object(collection);
    }

    public(friend) fun new(ctx: &mut TxContext) : MintCap {
        let mint_cap = MintCap {
            id: object::new(ctx)
        };
        mint_cap
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

    public fun add_puzzle_round(m_cap:&MintCap, warrior_round:&mut WarriorRound, name:String, image_uri:String, json_uri:String ) {
        let len = (vector::length(&mut warrior_round.puzzle_rounds) as u8);
        let id = object::id(warrior_round);
        vector::push_back(&mut warrior_round.puzzle_rounds, PuzzleRound { 
            warrior_round: id, 
            puzzle_round: len,
            name,
            image_uri,
            json_uri
        })
    }



    public(friend) fun mint(
        mint_cap: &MintCap,
        name: String,
        warrior_round:u64,
        puzzle_round:u8,
        image_uri: String,
        json_uri: String,
        // Need to be mut because supply is capped at 10_000 Warrior_nfts
        
        //doesn't need to be warehouse - this is just the place NFTs 
        //get stored after creation for initial sale/mint
        //warehouse: &mut Warehouse<WarriorNft>,
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
}