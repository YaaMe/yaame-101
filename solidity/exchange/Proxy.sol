pragma solidity ^0.4.15;
contract Token {
    function transfer(address to, uint256 value) returns (bool _success);
}

contract ProxyConfig {
    function wallet() constant returns (address _wallet);
    function invoker() constant returns (address _invoker);
    function gasLimit() constant returns (uint256 _gas);
    function version() constant returns (uint256 _version);
}

contract Proxy {
    ProxyConfig config;
    uint256 version;
    address safeManager;
    address wallet;
    address invoker;
    uint256 gasLimit;
    bool disable = false;

    event Deposit(address _from, address _user, uint256 _value);
    event DepositFailed(address _from, address _user, uint256 _value);

    function Proxy(address _config, uint256 _version, address _safeManager, address _wallet, address _invoker, uint256 _gasLimit) {
        config = ProxyConfig(_config);
        version = _version;
        safeManager = _safeManager;
        wallet = _wallet;
        invoker = _invoker;
        gasLimit = _gasLimit;
    }

    modifier onlyFor(address _target) {
        if (msg.sender != _target) revert();
        _;
    }

    modifier checkOrUpdate(uint256 _version, bool _forceCheck) {
        if (version < _version || _forceCheck) {
            uint256 checkVersion = config.version();
            if (version < checkVersion && !disable) {
                wallet = config.wallet();
                invoker = config.invoker();
                gasLimit = config.gasLimit();
                version = checkVersion;
            }
        }
        _;
    }

    modifier isWorking() {
        if(disable) revert();
        _;
    }

    function ban() onlyFor(safeManager) {
        disable = true;
        wallet = safeManager;
        invoker = safeManager;
    }

    function() isWorking payable {
        if (wallet.call.gas(gasLimit).value(msg.value)()) {
            Deposit(msg.sender, tx.origin, msg.value);
        } else {
            DepositFailed(msg.sender, tx.origin, msg.value);
            revert();
        }
    }

    function proxyTransfer(address _contract, uint256 _tokenAmount, uint256 _version) checkOrUpdate(_version, false) onlyFor(invoker) returns (bool) {
        Token token = Token(_contract);
        return token.transfer(wallet, _tokenAmount);
    }
}
