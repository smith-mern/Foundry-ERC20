// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor(uint256 _initialSupply) ERC20("OurToken", "ET)") {
        _mint(msg.sender, _initialSupply);
    }
}
