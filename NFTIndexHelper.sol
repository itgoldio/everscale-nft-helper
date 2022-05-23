pragma ton-solidity = 0.58.1;

pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

contract NFTIndexHelper {
    
    TvmCell _codeIndex;
    TvmCell _codeIndexBasis;

    constructor(
        TvmCell codeIndex,
        TvmCell codeIndexBasis
    ) public {
        tvm.accept();

        _codeIndex = codeIndex;
        _codeIndexBasis = codeIndexBasis;
    }

    function indexCode(
        address collection,
        address owner
    ) public view responsible returns(TvmCell indexCode) {
        TvmBuilder salt;
        salt.store("nft");
        salt.store(collection);
        salt.store(owner);
        return {value: 0, flag: 64, bounce: false} tvm.setCodeSalt(_codeIndex, salt.toCell());
    }

    function indexCodeWithoutSalt() public view responsible returns (TvmCell indexCode) {
        return {value: 0, flag: 64, bounce: false} _codeIndex;
    }

    function indexCodeHash(
        address collection,
        address owner
    ) public view responsible returns (uint256 indexCodeHash) {
        TvmBuilder salt;
        salt.store("nft");
        salt.store(collection);
        salt.store(owner);
        TvmCell codeIndexWithSalt = tvm.setCodeSalt(_codeIndex, salt.toCell());
        return {value: 0, flag: 64, bounce: false} tvm.hash(codeIndexWithSalt);
    }

    function indexCodeHashWithoutSalt() public view responsible returns (uint256 indexCodeHash) {
        return {value: 0, flag: 64, bounce: false} tvm.hash(_codeIndex);
    }

    function indexBasisCodeHash() public view responsible returns (uint256 indexBasisCodeHash) {
        string stamp = "nft";
        TvmBuilder salt;
        salt.store(stamp);
        TvmCell codeIndexBasisWithSalt = tvm.setCodeSalt(_codeIndexBasis, salt.toCell());
        return {value: 0, flag: 64, bounce: false} tvm.hash(codeIndexBasisWithSalt);
    }

    function indexBasisCodeHashWithoutSalt() public view responsible returns (uint256 indexBasisCodeHash) {
       return {value: 0, flag: 64, bounce: false} tvm.hash(_codeIndexBasis); 
    }
    
}
