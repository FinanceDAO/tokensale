pragma solidity ^0.4.24;

import "@aragon/apps-token-manager/contracts/TokenManager.sol";
import "@aragon/apps-agent/contracts/Agent.sol";



contract TokenSale is AragonApp {
    using SafeMath for uint256;

    // Errors
    string private constant ERROR_EXCEEDED_HARDCAP = "ERROR_EXCEEDED_HARDCAP";
    string private constant ERROR_SALE_ENDED = "ERROR_SALE_ENDED";


    // Roles
    bytes32 constant public SET_TOKEN_MANAGER_ROLE = keccak256("SET_TOKEN_MANAGER_ROLE");
    bytes32 constant public SET_AGENT_ROLE = keccak256("SET_AGENT_ROLE");

    // State
    TokenManager public tokenManager;
    Agent public agent;
    uint256 public rate; // token units per wei
    uint256 public cap;
    uint256 public tokensSold;
    uint256 public saleEnd;


    // Events
    event TokensPurchased(address buyer, uint256 value, uint256 amount);



    /**
     * @param _tokenManager TokenManager for minted token
     */
    function initialize(TokenManager _tokenManager, Agent _agent, uint256 _rate, uint256 _cap, uint256 _time) public onlyInit {
        tokenManager = _tokenManager;
        agent = _agent;
        rate = _rate;
        cap = _cap;
        tokensSold = 0;
        saleEnd = now + _time;


        initialized();
    }

    function() external payable  {
        mint(msg.sender, msg.value);
    }

    /**
     * @notice mint equal tokens for eth
     */
    function mint(address to, uint256 value) public payable {
        require(tokensSold.add(value) < cap, ERROR_EXCEEDED_HARDCAP);
        require(saleEnd < now, ERROR_SALE_ENDED);


        uint256 amount = rate.mul(value);
        tokensSold = tokensSold.add(amount);
        tokenManager.mint(to, amount);
        agent.deposit.value(value)(ETH, value);
        emit TokensPurchased(to, value, amount);

    }
}