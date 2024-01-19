// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20{
     constructor(uint256 initialSupply) ERC20("Gold", "GLD") {
        _mint(msg.sender, initialSupply);
    }

    
    //回调功能的 ERC20Token
    function transferWithCallback_ERC20(address recipient, uint amount) external {
        transfer(recipient, amount);
        callTokenReceive(recipient,amount,"");
    }

    function transferWithCallback_NFT(address recipient, uint amount,bytes memory token_id) external {
        transfer(recipient, amount);
        callTokenReceive(recipient,amount,token_id);
    }
    

    
    function callTokenReceive(address to,uint amount,bytes memory data) internal {
        if(isContract(to)){
            (bool success,) = to.call(abi.encodeWithSignature("tokenReceive(address,uint,bytes)",msg.sender,amount,data));
            if(!success){
                revert("contract have no function of tokenReceive()!!");
            }
        }
        
    }
    function isContract(address to) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(to)
        }
        return size > 0;
    }

}