module asset_owner::FUNGIBLE_ASSET_TEST {
    #[test_only]
    use asset_owner::FUNGIBLE_ASSET::{create_fa, get_asset_count, get_asset, mint}; 

    #[test_only]
    use std::string::utf8;

    #[test_only]
    use std::debug;

    #[test_only]
    use std::signer;

    #[test(account= @0xCAFE)]
    fun test_create_fa(account: &signer) {
        create_fa(account, utf8(b"First coin"), utf8(b"FC"), utf8(b"https://avatars.githubusercontent.com/u/62602303?v=4"));
        debug::print(&get_asset_count(signer::address_of(account)));
        create_fa(account, utf8(b"Second coin"), utf8(b"SC"), utf8(b"https://avatars.githubusercontent.com/u/62602303?v=4"));
        debug::print(&get_asset(signer::address_of(account), 0));
        debug::print(&get_asset(signer::address_of(account), 1));
        mint(account, get_asset(signer::address_of(account), 0), signer::address_of(account), 100000000);
    }
}