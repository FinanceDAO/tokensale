pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/apps-vault/contracts/Vault.sol";
import "@aragon/apps-token-manager/contracts/TokenManager.sol";
import "@aragon/apps-shared-minime/contracts/MiniMeToken.sol";

contract TokenSale is AragonApp {
    using SafeMath for uint256;

    // Errors
    string private constant ERROR_ADDRESS_NOT_CONTRACT = "ERROR_ADDRESS_NOT_CONTRACT";
    string private constant ERROR_ZERO_ADDRESS = "BENEFICIARY_IS_THE_ZERO_ADDRESS";
    string private constant ERROR_ZERO_WEI = "WEI_AMOUNT_IS_ZERO";

    // Roles
    bytes32 constant public SET_TOKEN_MANAGER_ROLE = keccak256("SET_TOKEN_MANAGER_ROLE");
    bytes32 constant public SET_VAULT_ROLE = keccak256("SET_VAULT_ROLE");

    // State
    // token units per wei. If using 1 with 3 decimals called TKN. 1 wei == 1 unit, or 0.001 TKN.
    uint256 public rate;
    uint256 public tokensSold;
    uint256 public weiRaised;
    uint256 public cap;
    uint256 public closeTime;
    mapping (address => uint256) public tokensPurchaced;

    TokenManager public tokenManager;
    Vault public vault;


    // Events
    event SetTokenManager(address tokenManager);
    event SetVault(address vault);
    event TokensPurchased(address purchaser, address beneficiary, uint256 value, uint256 amount);

    /**
    * @notice Initialize TokenSale contract
    * @param _vault the vault
    * @param _tokenManager the tokenManager
    * @param _rate the rate
    * @param _cap the cap
    * @param _time the length of time in seconds sale lasts
    */
    function initialize(Vault _vault, TokenManager _tokenManager, uint256 _rate, uint256 _cap, uint256 _time) external onlyInit {
        tokenManager = _tokenManager;
        vault = _vault;
        rate = _rate;
        cap = _cap;
        weiRaised = 0;
        tokensSold = 0;
        closeTime = now +_time;

        initialized();
    }

    /**
    * @notice Buys tokens and sends to `beneficiary`.
    * @param beneficiary The address to mint to
    */
    function buyTokens(address beneficiary) public stillOpen payable {
        uint256 weiAmount = msg.value;
        require(beneficiary != address(0), ERROR_ZERO_ADDRESS);
        require(weiAmount != 0, ERROR_ZERO_WEI);

        uint256 tokens = weiAmount.mul(rate);
        tokensPurchaced[beneficiary] = weiAmount.add(tokensPurchaced[beneficiary]);
        tokenManager.mint(beneficiary, tokens);
        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
        vault.deposit.value(weiAmount);
    }

    /**
    * @notice Set the Token Manager to `_tokenManager`.
    * @param _tokenManager The new token manager address
    */
    function setTokenManager(address _tokenManager) external auth(SET_TOKEN_MANAGER_ROLE) {
        require(isContract(_tokenManager), ERROR_ADDRESS_NOT_CONTRACT);

        tokenManager = TokenManager(_tokenManager);
        emit SetTokenManager(_tokenManager);
    }

    /**
    * @notice Set the Vault to `_vault`.
    * @param _vault The new vault address
    */
    function setVault(address _vault) external auth(SET_VAULT_ROLE) {
        require(isContract(_tokenManager), ERROR_ADDRESS_NOT_CONTRACT);

        vault = Vault(_vault);
        emit SetVault(_vault);
    }

    /**
    * @dev Convenience function for getting the Minted Token in a radspec string
    */
    function getToken() public view returns (address) {
        return tokenManager.token();
    }

    modifier stillOpen() {
        require(closeTime < now);
        _;
    }
}
