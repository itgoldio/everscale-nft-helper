# NFT index helper

NFTIndexHelper addresses:

Devnet: `0:e7982fb2c60892956dd04f90e118db98ddda146c05742aa369466d2029c042e6`<br>
Mainnet: `0:696062236a4f2b421f4df23b9dd592e3f47d5abb810d97a4611973f0f6018cd0`

<h2 id="search_nftRoot">Search all tip4 collections of the network</h2>

The IndexBasis contract is used to search for all Collection contracts. Because the code of the Collection contracts may differ - it is impossible to find all tip 4 collections on the network. To simplify the search, an Index Basic contract was invented, issued by a Collection contract whose code is the one. With this, we can find all the IndexBasis contracts, which in turn will store the addresses of the Collection contracts.

Get the codeHash of the IndexBasis contract using the NFTIndexHelper contract:

```shell
tonos-cli run 0:e7982fb2c60892956dd04f90e118db98ddda146c05742aa369466d2029c042e6 indexBasisCodeHash '{"answerId": 0}' --abi NFTIndexHelper.abi.json

Running get-method...
Succeeded.
Result: {
  "indexBasisCodeHash": "0x51d2e5e5718525436e8179cd5450038c2f1dcf6e4fd8a2c1526d114aad0e0f84"
}
```

Using codeHash of the IndexBasis contract we can make a query in graphql:

```
query { 
    accounts 
    (filter : {
        code_hash :{eq : "51d2e5e5718525436e8179cd5450038c2f1dcf6e4fd8a2c1526d114aad0e0f84"}
    })
{
    id
}}
```
**Where** "51d2e5e5718525436e8179cd5450038c2f1dcf6e4fd8a2c1526d114aad0e0f84" - **codehash** of the IndexBasis contract

```
{
  "data": {
    "accounts": [
      {
        "id": "0:00a70f22964025297d9f3130fe00c5c25c827db5b72dff44179a29430c45858d"
      },
      {
        "id": "0:0e26495712d4f007e3d30e936952a16b4ed4f88c5dff7685683e2c6555eb2ef4"
      },
      {
        "id": "0:0f0242ff2413bf5c225d4b568e7965fd25aaf49f72025c184534cb985e6a6142"
      },
      ...
      {
        "id": "0:d62dec37d453741136b626176fc0935c7cf4c794d7f3b027cab93522223073bd"
      }
    ]
  }
}
```

Knowing the abi of the IndexBasis contract, we will call its get method getInfo:

```
tonos-cli run 0:00a70f22964025297d9f3130fe00c5c25c827db5b72dff44179a29430c45858d getInfo '{"answerId": 0}' --abi IndexBasis.abi.json
Input arguments:
 address: 0:00a70f22964025297d9f3130fe00c5c25c827db5b72dff44179a29430c45858d
  method: getInfo
  params: {"answerId": 0}
     abi: IndexBasis.abi.json
    ...
Connecting to:
        Url: net.ton.dev
        Endpoints: ["https://net1.ton.dev", "https://net5.ton.dev"]

Running get-method...
Succeeded.
Result: {
  "collection": "0:e044b3b8b00d2360dfaf593fa03df4f55249b53f1ae67d2e9919b633b0421020"
}
```

As a result, we get the address of the Collection contract.

<h2 id="search_by_nftRoot&owner">Search for all NFTs by owner and collection address</h2>

Calling the `indexCodeHash` method of the NFTIndexHelper contract, passing the address of the collection and the address of the owner

- passing collection address 0:89fc1823620306035d6b2fb91e819649d3e7c3c894dea967c1ee7d7d6d9e365c
- passing owner address 0:5eb79f5d5aa10fa4d80067b370984c9bc686f61a7810060a46353ea2c47527bd
  
We get:

```
Result: {
  "indexCodeHash": "0x993a53200c7aae1b340b6bb4d523e5868785fdd45849cf18353103d7b56906c0"
}
```

We received Index code_hash (Method calculated the code_hash based on TvmCell code + collection address)

**We get all index contracts related to this collection and the owner:**

```
query { accounts (filter : {
    code_hash :{eq : "993a53200c7aae1b340b6bb4d523e5868785fdd45849cf18353103d7b56906c0"}
})
{
    id
}}
{
```

Result:
```
{
  "data": {
    "accounts": [
      {
        "id": "0:18ec00c6b9c079748b4e288458ad8bf95916b079b0e6b5cb365059acdf796265"
      },
      {
        "id": "0:83d937c106ea0a8c50b92abde7d6f6988e3c8bd569d7307cd7cbcc6669ec574c"
      },
      {
        "id": "0:b0f6abfed369652f2ec03bcf7613adba7ff66e88a381c38805b870ccb19730d1"
      },
      {
        "id": "0:f53a448f9343ae19d29c2f1c92a5944e7bf81265c10e817a17e5f6ebdc3899f8"
      }
    ]
  }
}
```

Then, calling the **getInfo** method for each index, we get the address of the nft
```
Input arguments:
 address: 0:18ec00c6b9c079748b4e288458ad8bf95916b079b0e6b5cb365059acdf796265
  method: getInfo
  params: {"answerId": 0}
     abi: Index.abi.json
    ...
Connecting to:
        Url: https://net.ton.dev/
        Endpoints: []

Running get-method...

Succeeded.
Result: {
  "collection": "0:89fc1823620306035d6b2fb91e819649d3e7c3c894dea967c1ee7d7d6d9e365c",
  "owner": "0:5eb79f5d5aa10fa4d80067b370984c9bc686f61a7810060a46353ea2c47527bd",
  "nft": "0:6627c74eb98d0673cdd44609f6c436e49363918724e5683aa7803e46aea71c86"
}
```
***

<h2 id="search_nft_by_owner">Search for all owner's nfts (without binding to Collection address)</h2>

Calling the `indexCodeHash` method of the NFTIndexHelper contract, passing an empty address instead of the collection address and the owner's address

- passing collection address 0:0000000000000000000000000000000000000000000000000000000000000000
- passing owner address 0:5eb79f5d5aa10fa4d80067b370984c9bc686f61a7810060a46353ea2c47527bd
  
We get: 

```
Result: {
  "indexCodeHash": "0xbefb2ea782496c0573a271822599c298327b28133debeee5a62cb1c0fee56fcf"
}
```

We received Index code_hash (Method calculated the code_hash based on TvmCell code + collection address)

**We get all index contracts related to owner:**

```
Input:
query { accounts (filter : {
    code_hash :{eq : "befb2ea782496c0573a271822599c298327b28133debeee5a62cb1c0fee56fcf"}
})
{
    id
}}
```

Result:
```
{
  "data": {
    "accounts": [
      {
        "id": "0:17fb5b6a95a74984e62bb478e4aa5f9ab83b4e33d8eb21a3b661d0a9116954fe"
      },
      {
        "id": "0:2a66d67a3d4f138766426cde9e3b9b08259992a6fff5088f2373dd60f15835a6"
      },
      {
        "id": "0:651351332bad333df4ea079f0d05d281d292337d107991c6c1ce06a43a91074a"
      },
      {
        "id": "0:87be2fb3818917b5707d39cd31ae52bd511cf13bcd5532be357af1d60c87fc8d"
      }
    ]
  }
}
```
Then, calling the **getInfo** method for each index, we get the address of the nft

```
Input arguments:
 address: 0:18ec00c6b9c079748b4e288458ad8bf95916b079b0e6b5cb365059acdf796265
  method: getInfo
  params: {"answerId": 0}
     abi: Index.abi.json
    ...
Connecting to:
        Url: https://net.ton.dev/
        Endpoints: []

Running get-method...

Succeeded.
Result: {
  "collection": "0:89fc1823620306035d6b2fb91e819649d3e7c3c894dea967c1ee7d7d6d9e365c",
  "owner": "0:5eb79f5d5aa10fa4d80067b370984c9bc686f61a7810060a46353ea2c47527bd",
  "nft": "0:6627c74eb98d0673cdd44609f6c436e49363918724e5683aa7803e46aea71c86"
}
```