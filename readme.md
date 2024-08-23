# THIS PROJECT IS FOR TESTING OF TRADING APPLICATION

DEVNET_CONTRACT_OBJECT_ADDRESS="0x3b1375259091d93fc7f6abc8b1949f14e1c4c78946211cce777f05de1eced73a"


aptos move upgrade-object-package \
  --object-address $DEVNET_CONTRACT_OBJECT_ADDRESS \
  --named-addresses asset_owner=$DEVNET_CONTRACT_OBJECT_ADDRESS\
  --profile $PUBLISHER_PROFILE \
  --assume-yes --skip-fetch-latest-git-deps
