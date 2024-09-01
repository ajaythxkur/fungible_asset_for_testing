# THIS PROJECT IS FOR TESTING OF TRADING APPLICATION

DEVNET_CONTRACT_OBJECT_ADDRESS="0x3b1375259091d93fc7f6abc8b1949f14e1c4c78946211cce777f05de1eced73a"
TESTNET - 0xf4a9fb8ee7be85e2232f2ccde1ca669b0f1c9a77f3f740bfa88fd7d6d0371de9.

aptos move upgrade-object-package \
  --object-address $DEVNET_CONTRACT_OBJECT_ADDRESS \
  --named-addresses asset_owner=$DEVNET_CONTRACT_OBJECT_ADDRESS\
  --profile $PUBLISHER_PROFILE \
  --assume-yes --skip-fetch-latest-git-deps
