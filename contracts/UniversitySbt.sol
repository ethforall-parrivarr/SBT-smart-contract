// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract UniversityDegree is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address owner;
    
    constructor() ERC721("UniversityDegree","Degree") {
        owner = msg.sender;
    }
    // to which person we are issuing degree

    mapping(address => bool) public issuedDegree; // if person issued degree it will be true
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function issueDegree(address to) onlyOwner external{  //university
        issuedDegree[to] = true;
    }


    function claimDegree(string memory tokenURI) public returns(uint256){ // student
        require(issuedDegree[msg.sender],"Degree is not issued");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender,newItemId);
        _setTokenURI(newItemId, tokenURI);

        personToDegree[msg.sender] = tokenURI;
        issuedDegree[msg.sender] = false;

        return newItemId;
    }

    mapping(address=>string) public personToDegree;

}