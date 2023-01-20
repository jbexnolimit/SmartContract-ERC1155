// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract EtherWrapped is ERC1155, Ownable, Pausable, ERC1155Supply{
   
    uint256 public publicPrice = 0.00000001 ether;
    uint256 public maxSupply = 10000;

    constructor()
        ERC1155("https://bafybeicsdem7eplq5holpcfnn2cr7syrstwy75yc37flr2g4envndgw3xa.ipfs.nftstorage.link/")
    {}
    

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }


    // add supply tracking
    function mint(uint256 id, uint256 amount)
        public
        payable
    {
        require(id < 2, "Sorry! looks like you are trying to mint the wrong NFT");
        require(msg.value == publicPrice * amount, "WRONG! Not enough moeney sent");
         require(totalSupply(id) + amount <= maxSupply, "Sorry we have minted out!");
        _mint(msg.sender, id, amount, "");
    }


    function withdraw(address _addr) external onlyOwner {
        uint256 balance = address(this).balance;
        payable(_addr).transfer(balance);
    }

    function uri(uint256 _id) public view virtual override returns (string memory) {
        require(exists(_id), "URI: nonexistent token");

        return string(abi.encodePacked(super.uri(_id+1), Strings.toString(_id+1), ".json"));
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}