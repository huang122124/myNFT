// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {NftMarketplace} from "../src/NftMarketplace.sol";
import {MyToken} from "../src/MyToken.sol";
import {KasonNFT} from "../src/KasonNFT.sol";
import {Vm} from "forge-std/Vm.sol";

contract NftMarketplaceTest is Test {
    NftMarketplace public nft_market;
    MyToken public myToken;
    KasonNFT public nft;
    address public alice = address(1);
    address public buyer = address(2);
    address public seller = address(3);

    function setUp() public {
        vm.startPrank(alice);
        myToken = new MyToken(10000);
        nft = new KasonNFT(alice);
        nft_market = new NftMarketplace(address(nft), address(myToken));
        myToken.transfer(buyer, 100);
        vm.stopPrank();
    }

    function testListItem() public {
        vm.startPrank(seller);
        nft.safeMint(seller, "abc");
        nft.approve(address(nft_market), 0);
        nft_market.listItem(0, 13);
        uint price = nft_market.tokenPrice(0);
        assertEq(price, 13);
        vm.stopPrank();
    }

    function testBuyNFT() public {
        testListItem();
        vm.startPrank(buyer);
        myToken.approve(address(nft_market), 13);
        nft_market.buyNFT(0, 13);
        address owner = nft.ownerOf(0);
        assertEq(owner, buyer);
        vm.stopPrank();
    }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
