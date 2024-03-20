//hodl extension - kiosk extension to make sure a user only hodls acertain number of each warrior piece

//1. Add extension to User Kiosk
//2. enable place and lock
//3. use the extension bag to create a counter for each puzzle piece
//4. the key for the bag could be "warriorRound:puzzleRound", ie "0:10" and it would hold a u64 and increment

module warrior::hodl {
    use sui::object::UID;
    use sui::bag::{Self, Bag};
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::kiosk_extension;
    use sui::tx_context::{Self, TxContext};
    use std::string::String;
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

    public fun is_setup(kiosk: &Kiosk, ctx: &TxContext) {
        if (kiosk_extension::is_installed<HodlExtension>(kiosk) && kiosk_extension::is_enabled<HodlExtension>(kiosk)) {
            true
        }
        false
    }

    //k: "1:3", v: u64
    //"warrior_round:puzzle_piece"
    public fun get_hodl_count(
        kiosk: &Kiosk,
        key: String
    ) {
        let ext = HodlExtension {};
        let bag = kiosk_extension::storage<HodlExtension>(ext, kiosk);
        bag::borrow(bag, key)
    }

    public(friend) fun add_item(
        kiosk: &mut Kiosk,
        key: String,
     ) {
        let ext = HodlExtension {};
        let bag = kiosk_extension::storage_mut<HodlExtension>(ext, kiosk);
        if (bag::contains(bag, key)) {
            let v = bag::borrow_mut(bag, key);
            v = v + 1;
        } else {
            bag::add(bag, key, 1u8);
        }
     }

    public(friend) fun remove_item(
        kiosk: &mut Kiosk,
        key: String,
     ) {
        let ext = HodlExtension {};
        let bag = kiosk_extension::storage_mut<HodlExtension>(ext, kiosk);
        let v = bag::borrow_mut(bag, key);
        assert!(v != 0, EItemNotInKiosk);
        v = v - 1;
     }
}