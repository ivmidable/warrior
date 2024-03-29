#[allow(unused_use)]
module warrior::user_kiosk {
    use kiosk::{personal_kiosk, royalty_rule};
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::transfer_policy::{Self as policy, TransferPolicy, TransferPolicyCap};
    use sui::table::{Self, Table};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::package;
    use sui::object::{Self, UID, ID};
    use warrior::warrior_nft::WarriorNft;

    //OTW for publisher cap
    struct USER_KIOSK has drop {}

    struct Registry has key {
        id:UID,
        table: Table<address, bool>,
    }

    #[allow(lint(share_owned))]
    fun init(otw: USER_KIOSK, ctx: &mut TxContext) {
        let publisher = package::claim(otw, ctx);
        let registry = create_registry(ctx);
        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::share_object(registry)
    }
    
    #[allow(lint(share_owned))]
    fun create_registry(ctx: &mut TxContext) : Registry {
        Registry {
            id: object::new(ctx),
            table: table::new(ctx),
        }
    }

    public fun create_user_kiosk(registry:&mut Registry, ctx: &mut TxContext) : Kiosk {
        let (kiosk, kiosk_owner_cap) = kiosk::new(ctx);
        let pk_cap = personal_kiosk::new(&mut kiosk, kiosk_owner_cap, ctx);
        table::add(&mut registry.table, tx_context::sender(ctx), true);
        //transfer policy, tp_Cap, basis points, min amount
       
        //transfer::public_transfer(kiosk, tx_context::sender(ctx));
        personal_kiosk::transfer_to_sender(pk_cap, ctx);
        kiosk
    }

    //public fun 

    // Getters
    public fun has_kiosk(registry: &Registry, ctx: &TxContext) : bool {
        table::contains(&registry.table, tx_context::sender(ctx))
    }

    #[test_only]
    //Wrapper of module initializer for testing 
    public fun init_for_test(ctx: &mut TxContext) {
        init(USER_KIOSK {}, ctx); 
    }
}