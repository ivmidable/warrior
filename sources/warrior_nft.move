module warrior::warrior_nft {
    use std::string::{Self, String};

    use sui::transfer;
    use sui::url::{Self, Url};
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};

    use nft_protocol::mint_cap;
    use nft_protocol::mint_event;
    use nft_protocol::collection::{Self, Collection};
    use nft_protocol::display_info;
    use nft_protocol::mint_cap::{MintCap};
    use ob_permissions::witness;

    use ob_launchpad::warehouse::{Self, Warehouse};

    //One time witness is only instantiated in the init method
    struct WARRIOR_NFT has drop {}

    struct WarriorNft has key, store {
        id: UID, //UID for Sui Global Store
        round:u64, //which warrior round this belongs to.
        type:u8, //Puzzle piece number
        name: String,
        url: Url,
    }

    /// Can be used for authorization of other actions post-creation. It is
    /// vital that this struct is not freely given to any contract, because it
    /// serves as an auth token.
    struct Witness has drop {}

    #[lint_allow(share_owned, self_transfer)]
    fun init(otw: WARRIOR_NFT, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        // Create Collection
        let dw = witness::from_witness(Witness {});
        let collection: Collection<WARRIOR_NFT> = collection::create(dw, ctx);
        let collection_id = object::id(&collection);

        // Initialize per-type MintCaps
        let mint_cap_warrior: MintCap<WarriorNft> =
            mint_cap::new_unlimited(&otw, collection_id, ctx);

        // let mint_cap_piece: MintCap<Piece> =
        //     mint_cap::new_unlimited(&otw, collection_id, ctx);

        // let mint_cap_skin: MintCap<Skin> =
        //     mint_cap::new_unlimited(&otw, collection_id, ctx);

        // Init Publisher
        let publisher = sui::package::claim(otw, ctx);

        // Add name and description to Collection
        collection::add_domain(
            dw,
            &mut collection,
            display_info::new(
                string::utf8(b"WarriorNft"),
                string::utf8(b"A description"),
            ),
        );

        transfer::public_transfer(mint_cap_warrior, sender);
        transfer::public_transfer(publisher, sender);
        transfer::public_share_object(collection);
    }

    public entry fun mint_warrior_nft(
        name: String,
        round:u64,
        type:u8,
        url: vector<u8>,
        // Need to be mut because supply is capped at 10_000 Warrior_nfts
        mint_cap: &mut MintCap<WarriorNft>,
        //doesn't need to be warehouse - this is just the place NFTs 
        //get stored after creation for initial sale/mint
        warehouse: &mut Warehouse<WarriorNft>,
        ctx: &mut TxContext,
    ) {
        let nft = WarriorNft {
            id: object::new(ctx),
            name,
            round,
            type,
            url: url::new_unsafe_from_bytes(url),
        };

        mint_cap::increment_supply(mint_cap, 1);
        mint_event::emit_mint(
            witness::from_witness(Witness {}),
            mint_cap::collection_id(mint_cap),
            &nft,
        );

        warehouse::deposit_nft(warehouse, nft);
    }

    public fun get_type(warrior_nft: &WarriorNft) : u8 {
        warrior_nft.type
    }

    #[test_only]
    use sui::test_scenario::{Self, ctx};
    #[test_only]
    const USER: address = @0xA1C04;

    #[test]
    fun it_inits_collection() {
        let scenario = test_scenario::begin(USER);
        init(WARRIOR_NFT {}, ctx(&mut scenario));

        test_scenario::end(scenario);
    }
}