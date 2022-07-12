async function main() {
  const Collection = await locklift.factory.getContract('NFTIndexHelper');
  const Index = await locklift.factory.getContract('Index');
  const IndexBasis = await locklift.factory.getContract('IndexBasis');
  const [keyPair] = await locklift.keys.getKeyPairs();

  const collection = await locklift.giver.deployContract({
    contract: Collection,
    constructorParams: {
      codeIndex : Index.code,
      codeIndexBasis : IndexBasis.code
    },
    initParams: {},
    keyPair,
  }, locklift.utils.convertCrystal(5, 'nano'));
  
  console.log(`Collection deployed at: ${collection.address}`);
}

main()
  .then(() => process.exit(0))
  .catch(e => {
    console.log(e);
    process.exit(1);
  });
