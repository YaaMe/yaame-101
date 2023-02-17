pragma solidity ^0.4.15;
contract ProxyConfig {
    function wallet() constant returns (address _wallet);
    function invoker() constant returns (address _invoker);
    function gasLimit() constant returns (uint256 _gas);
    function version() constant returns (uint256 _version);
}

contract Config is ProxyConfig {
    address owner;
    address wallet;
    address invoker;
    uint256 gasLimit;
    uint256 version;

    function Config(address _wallet,, address _invoker, uint256 _gasLimit) {
        owner = msg.sender;
        wallet = _wallet;
        invoker = _invoker;
        gasLimit = _gasLimit;
        version = 1;
    }
}

modifier onlyOwner() {
    if (msg.sender != owner) revert();
    _;
}

function safeAdd(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c >= a);
    return c;
}

modifier updateVersion() {
    version = safeAdd(version, 1);
    _;
}

function resetWallet(address _new) onlyOwner updateVersion returns (bool) {
    wallet = _new;
    return true;
}

function resetInvoker(address _new) onlyOwner updateVersion returns (bool) {
    invoker = _new;
    return true;
}

function resetGasLimit(uint256 _gasLimit) onlyOwner updateVersion returns (bool) {
    gasLimit = _gasLimit;
    return true;
}

function wallet() constant returns (address) {
    return wallet;
}

function invoker() constant returns (address) {
    return invoker;
}

function gasLimit() constant returns (uint256) {
    return gasLimit;
}

function version() constant returns (uint256) {
    return version;
}