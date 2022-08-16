# NFT index helper

NFTIndexHelper addresses:

Devnet: `0:e7982fb2c60892956dd04f90e118db98ddda146c05742aa369466d2029c042e6`<br>
Mainnet: `0:696062236a4f2b421f4df23b9dd592e3f47d5abb810d97a4611973f0f6018cd0`

<h2 id="search_nftRoot">Search all tip4 collections of the network</h2>

Для поиска всех контрактов Collection используется IndexBasis. Т.к. код контрактов Collection может отличаться - просто найти все tip4 коллекции в сети невозможно. Для упрощения поиска был придуман контракт IndexBasis, выпускаемый Collection контрактом, код которого един. За счет этого мы можем найти все контракты IndexBasis, которые в свою очередь будут хранить адреса контрактов Collection.

Получим codeHash контракта IndexBasis используя контракт NFTIndexHelper:

```shell
tonos-cli run 0:e7982fb2c60892956dd04f90e118db98ddda146c05742aa369466d2029c042e6 indexBasisCodeHash '{"answerId": 0}' --abi NFTIndexHelper.abi.json

Running get-method...
Succeeded.
Result: {
  "indexBasisCodeHash": "0x51d2e5e5718525436e8179cd5450038c2f1dcf6e4fd8a2c1526d114aad0e0f84"
}
```

Используя codeHash контракта IndexBasis мы можем сделать запрос в graphql:

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
**где** "51d2e5e5718525436e8179cd5450038c2f1dcf6e4fd8a2c1526d114aad0e0f84" - **codehash** контракта IndexBasis

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

Зная abi контракта IndexBasis вызовем его get метод getInfo:
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

В итоге получаем адрес контракта Collection.

<h2 id="search_by_nftRoot&owner">Поиск всех nft по владельцу и collection адресу</h2>

Вызываем метод `indexCodeHash` у NFTIndexHelper контракта, передавая адрес коллекции и адрес владельца

- передаём collection 0:89fc1823620306035d6b2fb91e819649d3e7c3c894dea967c1ee7d7d6d9e365c
- передаём owner 0:5eb79f5d5aa10fa4d80067b370984c9bc686f61a7810060a46353ea2c47527bd
Получаем 

```
Result: {
  "indexCodeHash": "0x993a53200c7aae1b340b6bb4d523e5868785fdd45849cf18353103d7b56906c0"
}
```

Получили code hash Index контракта (Метод высчитал code hash на основе TvmCell code + collection address)

**Получаем все index контракты, относящиеся к этой коллекции и владельцу:**

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

Затем вызвав у каждого index метод **getInfo** получим адрес nft
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

<h2 id="search_nft_by_owner">Поиск всех nft владельца (без привязки к Collection address)</h2>

Вызываем метод `indexCodeHash` у NFTIndexHelper контракта, передавая пустой адрес вместо адреса коллекции и адрес владельца

- передаём collection 0:0000000000000000000000000000000000000000000000000000000000000000
- передаём owner 0:5eb79f5d5aa10fa4d80067b370984c9bc686f61a7810060a46353ea2c47527bd
Получаем 

```
Result: {
  "indexCodeHash": "0xbefb2ea782496c0573a271822599c298327b28133debeee5a62cb1c0fee56fcf"
}
```

Получили code hash Index контракта (Метод высчитал code hash на основе TvmCell code + collection)

**Получаем все index контракты владельца: (всех tip4 коллекций)**

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
Для того, чтобы узнать адрес nft - нужно у index вызвать метод getInfo

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

<h2 id="getAllCollectionNfts">Получить все NFT коллекции</h2>

Зная адрес контракта коллекции мы можем обратиться к нему для получения nftCodeHash:

```
tonos-cli --url "eri01.main.everos.dev" run 0:999fa9e3331291a2fc2291a5663ef893733c838a3f4d0c5411378f4724f626d2 nftCodeHash '{"answerId": 0}' --abi Collection.abi.json

Result: {
  "codeHash": "0xfaddff7ca7b512e3e83c108f65f474a71c4ec175a2f66db56494dddb501325b7"
}
```

**Получаем все nft контракты коллекции:**

```
query { accounts (filter : {
    code_hash :{eq : "faddff7ca7b512e3e83c108f65f474a71c4ec175a2f66db56494dddb501325b7"}
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
        "id": "0:077ffc6a036d60cac5e3befebee2f38912d4ed482104639aa6e129f463f709c3"
      },
      {
        "id": "0:0aa9f70bc2e246576a9d50950a95e49ec3f66187316edadfde9188f343f5d6ce"
      },
      {
        "id": "0:11a45dd24fb17b60d7714c32ff610c713bb7eba21bcc7137a2e1a15b41c10ffc"
      },
      {
        "id": "0:1290192bc094a5a557982e0c4b58d243ca33e14fbcbc1fc45e896e4d4a596076"
      },
      ...
      {
        "id": "0:ef856ca29805988fae41f8081f213118503546e05b765adb03ef4aaa8f654c8f"
      }
    ]
  }
}
```