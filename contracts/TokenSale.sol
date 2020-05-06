pragma solidity ^0.4.24;

import "@aragon/apps-token-manager/contracts/TokenManager.sol";
import "@aragon/apps-agent/contracts/Agent.sol";


contract TokenSale is AragonApp {

    bytes32 public constant DUMMIE_ROLE = keccak256("DUMMIE_ROLE");

    TokenManager public tokenManager;
    Agent public agent;


    /**
     * @param _tokenManager TokenManager for minted token
     */
    function initialize(TokenManager _tokenManager, Agent _agent) public onlyInit {
        tokenManager = _tokenManager;
        agent = _agent;

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
        agent.deposit.value(value)(ETH, value);
    }
}