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
    use nft_protocol::composable_nft::{Self as c_nft};
    use ob_permissions::witness;

    use ob_launchpad::warehouse::{Self, Warehouse};

    //One time witness is only instantiated in the init method
    struct WARRIOR_NFT has drop {}

    struct Warrior_nft has key, store {
        id: UID,
        piece: u8,
        name: String,
        url: Url,
    }

    // struct Hair has key, store {
    //     id: UID,
    //     type: String,
    // }

    // struct Skin has key, store {
    //     id: UID,
    //     type: String
    // }

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
        let mint_cap_overdrive: MintCap<Warrior_nft> =
            mint_cap::new_limited(&otw, collection_id, 10_000, ctx);

        // let mint_cap_hair: MintCap<Hair> =
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
                string::utf8(b"Warrior_nft"),
                string::utf8(b"A description"),
            ),
        );

        // === Warrior_nft composability ===

        let overdrive_blueprint = c_nft::new_composition<Warrior_nft>();
        // c_nft::add_relationship<Warrior_nft, Hair>(
        //     &mut overdrive_blueprint, 1,
        // );
        // c_nft::add_relationship<Warrior_nft, Skin>(
        //     &mut overdrive_blueprint, 1,
        // );

        collection::add_domain(
            dw, &mut collection, overdrive_blueprint,
        );

        transfer::public_transfer(mint_cap_warrior_nft, sender);
        //transfer::public_transfer(mint_cap_hair, sender);
        //transfer::public_transfer(mint_cap_skin, sender);
        transfer::public_transfer(publisher, sender);
        transfer::public_share_object(collection);
    }

    public entry fun mint_warrior_nft(
        name: String,
        color: String,
        mood: String,
        url: vector<u8>,
        // Need to be mut because supply is capped at 10_000 Warrior_nfts
        mint_cap: &mut MintCap<Warrior_nft>,
        //doesn't need to be warehouse - this is just the place NFTs 
        //get stored after creation for initial sale/mint
        warehouse: &mut Warehouse<Warrior_nft>,
        ctx: &mut TxContext,
    ) {
        let nft = Warrior_nft {
            id: object::new(ctx),
            name,
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

    public fun get_piece(warrior_nft: &Warrior_nft) : u8 {
        warrior_nft.piece
    }

    // public entry fun mint_hair(
    //     type: String,
    //     // Does not need to be mut because supply is unregulated
    //     mint_cap: &MintCap<Hair>,
    //     warehouse: &mut Warehouse<Hair>,
    //     ctx: &mut TxContext,
    // ) {
    //     let nft = Hair {
    //         id: object::new(ctx),
    //         type,
    //     };

    //     mint_event::emit_mint(
    //         witness::from_witness(Witness {}),
    //         mint_cap::collection_id(mint_cap),
    //         &nft,
    //     );

    //     warehouse::deposit_nft(warehouse, nft);
    // }

    // public entry fun mint_skin(
    //     type: String,
    //     // Does not need to be mut because supply is unregulated
    //     mint_cap: &MintCap<Skin>,
    //     warehouse: &mut Warehouse<Skin>,
    //     ctx: &mut TxContext,
    // ) {
    //     let nft = Skin {
    //         id: object::new(ctx),
    //         type,
    //     };

    //     mint_event::emit_mint(
    //         witness::from_witness(Witness {}),
    //         mint_cap::collection_id(mint_cap),
    //         &nft,
    //     );

    //     warehouse::deposit_nft(warehouse, nft);
    // }

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