#[allow(unused_use)]
module warrior::minting_kiosk {
    //use kiosk::{Self}
    use sui::kiosk::{Self, Kiosk, KioskOwnerCap};
    use sui::tx_context::{Self, TxContext};
    use warrior::warrior_nft::create_nft;

    fun init(_ctx: &mut TxContext) {
        //let (kiosk, k_owner_cap) = kiosk::new(ctx);
        //let mint_owner_cap = warrior_nft::
        //transfer::transfer(WarriorConfigCap {id:object::new(ctx)}, tx_context::sender(ctx))
    }

    


}