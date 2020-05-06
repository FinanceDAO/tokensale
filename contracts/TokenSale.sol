pragma solidity ^0.4.24;

import "@aragon/apps-token-manager/contracts/TokenManager.sol";

contract TokenSale is AragonApp {

    bytes32 public constant DUMMIE_ROLE = keccak256("DUMMIE_ROLE");
    TokenManager public tokenManager;

    /**
     * @param _tokenManager TokenManager for minted token
     */
    function initialize(TokenManager _tokenManager) public onlyInit {
        tokenManager = _tokenManager;

        initialized();
    }

    function() external payable  {
        mint(msg.sender, msg.value);
    }

    /**
     * @notice mint equal tokens for eth
     */
    function mint(address to, uint256 value) public payable {
        tokenManager.mint(to, value);
    }
}