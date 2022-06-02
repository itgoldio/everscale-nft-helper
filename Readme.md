# Everscale NFT helper

Evescale NFT standard [TIP-4.3](https://docs.everscale.network/standard/TIP-4/3) describe indexes for NFT searching

All indexes has equal code. We don't need use it functions on every NFT and can use helper contracts to facilitate the search. 


[NFTIndexHelper](build/NFTIndexHelper.abi.json)

Deployed on mainnet 
``0:696062236a4f2b421f4df23b9dd592e3f47d5abb810d97a4611973f0f6018cd0``

Deployed on devnet 

## IndexBasis

It used for search NFT collection.

Every **IndexBasis** has equals codehash ``0x2359f897c9527073b1c95140c670089aa5ab825f5fd1bd453db803fbab47def2``

For NFT we sold it use a stamp = "nft"

[NFTIndexHelper](NFTIndexHelper.sol) return **IndexBasis** after sold.
``0x51d2e5e5718525436e8179cd5450038c2f1dcf6e4fd8a2c1526d114aad0e0f84``