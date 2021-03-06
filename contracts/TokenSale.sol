pragma solidity ^0.4.24;

import "@aragon/apps-token-manager/contracts/TokenManager.sol";
import "@aragon/apps-agent/contracts/Agent.sol";



contract TokenSale is AragonApp {
    using SafeMath for uint256;


    // Errors
    string private constant ERROR_EXCEEDED_HARDCAP = "ERROR_EXCEEDED_HARDCAP";
    string private constant ERROR_ADDRESS_NOT_CONTRACT = "ERROR_ADDRESS_NOT_CONTRACT";
    string private constant ERROR_SALE_CLOSED = "ERROR_SALE_CLOSED";
    string private constant ERROR_SALE_OPEN = "ERROR_SALE_OPEN";
    

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
    bool public isOpen;


    // Events
    event TokensPurchased(address indexed buyer, uint256 value, uint256 amount);
    event SetTokenManager(address indexed tokenManager);
    event SetAgent(address indexed agent);
    event SaleOpen(uint256 rate, uint256 cap);
    event SaleClosed(uint256 tokensSold);



    function initialize(TokenManager _tokenManager, Agent _agent) public onlyInit {
        tokenManager = _tokenManager;
        agent = _agent;
        tokensSold = 0;
        isOpen = false;

        initialized();
    }

    function() external payable  {
        mint(msg.sender, msg.value);
    }

    function mint(address to, uint256 value) public payable {
        require(tokensSold.add(value) < cap, ERROR_EXCEEDED_HARDCAP);
        require(isOpen == true, ERROR_SALE_CLOSED);

        uint256 amount = rate.mul(value);
        tokensSold = tokensSold.add(amount);
        tokenManager.mint(to, amount);
        agent.deposit.value(value)(ETH, value);
        emit TokensPurchased(to, value, amount);

    }


    function openSale(uint256 _rate, uint256 _cap) external auth(OPEN_SALE_ROLE) {
        require(isOpen == false, ERROR_SALE_OPEN);

        rate = _rate;
        cap = _cap;
        tokensSold = 0;
        isOpen = true;
        emit SaleOpen(rate, cap);
    }


    function closeSale() external auth(CLOSE_SALE_ROLE) {
        require(isOpen == true, ERROR_SALE_CLOSED);

        isOpen = false;
        emit SaleClosed(tokensSold);
    }

    function setTokenManager(address _tokenManager) external auth(SET_TOKEN_MANAGER_ROLE) {
        require(isContract(_tokenManager), ERROR_ADDRESS_NOT_CONTRACT);
        require(isOpen == false, ERROR_SALE_OPEN);

        tokenManager = TokenManager(_tokenManager);
        emit SetTokenManager(_tokenManager);
    }

    function setAgent(address _agent) external auth(SET_AGENT_ROLE) {
        require(isContract(_agent), ERROR_ADDRESS_NOT_CONTRACT);

        agent = Agent(_agent);
        emit SetAgent(_agent);
    }
}
