pragma ton-solidity = 0.58.2;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

contract NFTIndexHelper {
    
    TvmCell _codeIndex;

    constructor(TvmCell codeIndex) public {
        tvm.accept();

        _codeIndex = codeIndex;
    }

    function resolveCodeHashNftIndex(
        address collection,
        address owner
    ) public view returns (uint256) {
        TvmBuilder salt;
        salt.store("nft");
        salt.store(collection);
        salt.store(owner);
        return tvm.hash(tvm.setCodeSalt(_codeIndex, salt.toCell()));
    }
}
