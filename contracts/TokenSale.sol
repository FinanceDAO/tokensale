pragma solidity ^0.4.24;

import "@aragon/apps-token-manager/contracts/TokenManager.sol";
import "@aragon/apps-agent/contracts/Agent.sol";



contract TokenSale is AragonApp {
    using SafeMath for uint256;

    // Errors
    string private constant ERROR_EXCEEDED_HARDCAP = "ERROR_EXCEEDED_HARDCAP";
    string private constant ERROR_ADDRESS_NOT_CONTRACT = "ERROR_ADDRESS_NOT_CONTRACT";
    

    // Roles
    bytes32 constant public SET_TOKEN_MANAGER_ROLE = keccak256("SET_TOKEN_MANAGER_ROLE");
    bytes32 constant public SET_AGENT_ROLE = keccak256("SET_AGENT_ROLE");
    bytes32 constant public OPEN_SALE_ROLE = keccak256("OPEN_SALE_ROLE");
    bytes32 constant public CLOSE_SALE_ROLE = keccak256("CLOSE_SALE_ROLE");
    


    // State
    TokenManager public tokenManager;
    Agent public agent;
    uint256 public rate; // fractional value in ETH
    uint256 public cap;
    uint256 public tokensSold;
    uint256 TOKEN_CONST = 1000000000000000000;
    bool public isOpen;


    // Events
    event TokensPurchased(address buyer, uint256 value, uint256 amount);
    event SetTokenManager(address tokenManager);
    event SetAgent(address agent);



    function initialize(TokenManager _tokenManager, Agent _agent, uint256 _rate, uint256 _cap) public onlyInit {
        tokenManager = _tokenManager;
        agent = _agent;
        rate = TOKEN_CONST.mul(_rate);
        cap = _cap;
        tokensSold = 0;
        isOpen = true;

        initialized();
    }

    function() external payable  {
        mint(msg.sender, msg.value);
    }

    function mint(address to, uint256 value) public payable {
        require(tokensSold.add(value) < cap, ERROR_EXCEEDED_HARDCAP);

        uint256 amount = rate.mul(value);
        tokensSold = tokensSold.add(amount);
        tokenManager.mint(to, amount);
        agent.deposit.value(value)(ETH, value);
        emit TokensPurchased(to, value, amount);

    }

    function setTokenManager(address _tokenManager) external auth(SET_TOKEN_MANAGER_ROLE) {
        require(isContract(_tokenManager), ERROR_ADDRESS_NOT_CONTRACT);

        tokenManager = TokenManager(_tokenManager);
        emit SetTokenManager(_tokenManager);
    }

    function setAgent(address _agent) external auth(SET_AGENT_ROLE) {
        require(isContract(_agent), ERROR_ADDRESS_NOT_CONTRACT);

        agent = Agent(_agent);
        emit SetAgent(_agent);
    }
}
