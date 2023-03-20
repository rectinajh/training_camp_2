//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";

interface TokenRecipient {
    function tokensReceived(address sender, uint amount, bytes memory exData) external returns (bool);
}

contract MyERC20 is ERC20 {
    using Address for address;

    constructor() ERC20("MyERC20", "MyERC20") {
        _mint(msg.sender, 1000 * 10 ** 18);
    }


    function send(address recipient, uint256 amount, bytes calldata exData) external returns (bool) {
        _transfer(msg.sender, recipient, amount);

        if (recipient.isContract()) {
            bool rv = TokenRecipient(recipient).tokensReceived(msg.sender, amount, exData);
            require(rv, "No tokensReceived");
        }

        return true;
    }


}