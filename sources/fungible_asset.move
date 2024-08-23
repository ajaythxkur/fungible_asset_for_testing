module asset_owner::FUNGIBLE_ASSET {
    use std::signer;
    use std::vector;
    use aptos_framework::object::{Self, Object};
    use aptos_framework::primary_fungible_store;
    use aptos_framework::fungible_asset::{Self, MintRef, TransferRef, Metadata};
    use std::option;
    use std::string::{String, utf8};
    use std::bcs;
    use aptos_std::string_utils;

    // Uncomment for testing
    // friend asset_owner::FUNGIBLE_ASSET_TEST; 

    struct AssetManagement has key {
        mint_ref: MintRef,
        transfer_ref: TransferRef,
        // burn_ref: BurnRef
    }
    // Store them off chain
    struct AssetList has key {
        assets: vector<address>, 
    }

    const EASSET_LIST_DOESNT_EXIST: u64 = 0;
    const EASSET_INDEX_DOESNT_EXIST: u64 = 1;
    const ENOT_OWNER: u64 = 2;

    public(friend) entry fun create_fa(account: &signer, name: String, symbol: String, uri: String) acquires AssetList {
        let account_address = signer::address_of(account);
        let asset_symbol = string_to_bytes(symbol);
        let obj_holds_asset = &object::create_named_object(account, asset_symbol);
        primary_fungible_store::create_primary_store_enabled_fungible_asset(
            obj_holds_asset,
            option::none(), // supply
            name, // name
            symbol, // symbol
            8, // decimals
            uri, // icon uri
            utf8(b"https://github.com/ajaythxkur"), // project uri
        );
        let obj_signer = &object::generate_signer(obj_holds_asset);
        move_to(obj_signer, AssetManagement {
            mint_ref: fungible_asset::generate_mint_ref(obj_holds_asset),
            transfer_ref: fungible_asset::generate_transfer_ref(obj_holds_asset),
        });
        let asset_address = object::create_object_address(&account_address, asset_symbol);
        if(exists<AssetList>(account_address)){
            let assets = &mut borrow_global_mut<AssetList>(account_address).assets;
            vector::push_back(assets, asset_address);
        }else {
            move_to(account, AssetList {
                assets: vector::singleton(asset_address),
            });
        };
    }

    public(friend) entry fun mint(account: &signer, asset_addr: address, to: address, amount: u64) acquires AssetManagement {
        let asset = asset_metadata(asset_addr);
        let asset_management = authorized_borrow_refs(account, asset);
        let to_wallet = primary_fungible_store::ensure_primary_store_exists(to, asset);
        let fa = fungible_asset::mint(&asset_management.mint_ref, amount);
        fungible_asset::deposit_with_ref(&asset_management.transfer_ref, to_wallet, fa);
    }

    inline fun authorized_borrow_refs(
        owner: &signer,
        asset: Object<Metadata>,
    ): &AssetManagement acquires AssetManagement {
        assert_is_asset_owner(signer::address_of(owner), asset);
        borrow_global<AssetManagement>(object::object_address(&asset))
    }

    #[view]
    public fun get_asset_count(addr: address): u64 acquires AssetList {
        assert_asset_list_exists(addr);
        vector::length(&borrow_global<AssetList>(addr).assets)
    }

    #[view]
    public fun get_asset(addr: address, idx: u64): address acquires AssetList {
        assert_asset_list_exists(addr);
        let assets = &borrow_global<AssetList>(addr).assets;
        assert_asset_index_exists(assets, idx);
        *vector::borrow(assets, idx)
    }
 
    // ============== Asserts ============== //
    fun assert_asset_list_exists(addr: address) {
        assert!(exists<AssetList>(addr), EASSET_LIST_DOESNT_EXIST);
    }
    fun assert_asset_index_exists(assets: &vector<address>, idx: u64){
        assert!(vector::length(assets) > idx, EASSET_INDEX_DOESNT_EXIST);
    }
    fun assert_is_asset_owner(owner: address, asset: Object<Metadata>){
        assert!(object::is_owner(asset, owner), ENOT_OWNER);
    }

    // ============== Helper functions ============== //
    fun string_to_bytes(str: String): vector<u8> {
        bcs::to_bytes(&string_utils::format1(&b"{}", str))
    }
    fun asset_metadata(addr: address): Object<Metadata> {
        object::address_to_object<Metadata>(addr)
    }

    

}