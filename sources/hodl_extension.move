//hodl extension - kiosk extension to make sure a user only hodls acertain number of each warrior piece

//1. Add extension to User Kiosk
//2. enable place and lock
//3. use the extension bag to create a counter for each puzzle piece
//4. the key for the bag could be "warriorRound:puzzleRound", ie "0:10" and it would hold a u64 and increment

module warrior::hodl {
    use sui::object::UID;
    use sui::bag::{Self};
    use sui::kiosk::{Kiosk, KioskOwnerCap};
    use sui::kiosk_extension;
    use sui::tx_context::{TxContext};
    use kiosk::personal_kiosk;

    /// Not a personal Kiosk
    const ENotPersonalKiosk: u64 = 0;
    const EItemNotInKiosk: u64 = 1;

    //friends that can call friend functions.
    friend warrior::hodl_rule;
    friend warrior::mint;

    struct HodlExtension has drop {}

    struct Hodl has key {
        id:UID
    }
    
    //add extension to personal kiosk
    public fun add(
        cap: &KioskOwnerCap,
        kiosk: &mut Kiosk,
        ctx: &mut TxContext
     ) {
        assert!(personal_kiosk::is_personal(kiosk), ENotPersonalKiosk);
        let ext = HodlExtension {};
        kiosk_extension::add<HodlExtension>(ext, kiosk, cap, 3, ctx)
     }

    public fun is_setup(kiosk: &Kiosk, _ctx: &TxContext): bool {
        kiosk_extension::is_installed<HodlExtension>(kiosk) && kiosk_extension::is_enabled<HodlExtension>(kiosk)
    }

    //k: "1:3", v: u64
    //"warrior_round:puzzle_piece"
    public fun get_hodl_count(
        kiosk: &Kiosk,
        key: u64
    ): u64 {
        let ext = HodlExtension {};
        let bag = kiosk_extension::storage<HodlExtension>(ext, kiosk);
        *bag::borrow<u64, u64>(bag, key)
    }

    public(friend) fun add_item(
        kiosk: &mut Kiosk,
        key: u64,
    ) {
        let ext = HodlExtension {};
        let bag = kiosk_extension::storage_mut<HodlExtension>(ext, kiosk);
        let current_count = if (bag::contains(bag, key)) {
            *bag::borrow_mut<u64, u64>(bag, key)
        } else {
            0u64
        };
        let new_count = current_count + 1;
        bag::add(bag, key, new_count);
    }

    public(friend) fun remove_item(
        kiosk: &mut Kiosk,
        key: u64,
    ) {
        let ext = HodlExtension {};
        let bag = kiosk_extension::storage_mut<HodlExtension>(ext, kiosk);

        assert!(bag::contains(bag, key), EItemNotInKiosk);
        let current_count = *bag::borrow_mut<u64, u64>(bag, key); 

        assert!(current_count != 0, EItemNotInKiosk);

        let new_count = current_count - 1;

        let removed_value: u64 = bag::remove<u64, u64>(bag, key);
        if (new_count > 0) {
            bag::add(bag, key, new_count); 
        }
    }
}