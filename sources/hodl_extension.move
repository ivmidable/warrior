//hodl extension - kiosk extension to make sure a user only hodls acertain number of each warrior piece

//1. Add extension to User Kiosk
//2. enable place and lock
//3. use the extension bag to create a counter for each puzzle piece
//4. the key for the bag could be "warriorRound:puzzleRound", ie "0:10" and it would hold a u64 and increment

module warrior::hodl {
    use sui::object::UID;
    //
    struct HodlExtension has drop {}

    struct Hodl has key {
        id:UID
    }
}