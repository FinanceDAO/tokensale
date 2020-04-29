pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/apps-vault/contracts/Vault.sol";
import "@aragon/apps-token-manager/contracts/TokenManager.sol";
import "@aragon/apps-shared-minime/contracts/MiniMeToken.sol";

contract TokenSale is AragonApp {
    using SafeMath for uint256;

    // Roles
    bytes32 constant public SET_TOKEN_MANAGER_ROLE = keccak256("SET_TOKEN_MANAGER_ROLE");
    bytes32 constant public SET_VAULT_ROLE = keccak256("SET_VAULT_ROLE");


    // State
    // How many token units a buyer gets per wei.
    // So, if you are using a rate of 1 with 3 decimals called TKN. 1 wei will give you 1 unit, or 0.001 TOK.
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
    */
    function initialize(Vault _vault, TokenManager _tokenManager, uint256 _rate, uint256 _cap, uint256 _time) external onlyInit {
        tokenManager = _tokenManager;
        vault = _vault;
        rate = _rate;
        cap = _cap;
        weiRaised = 0;
        tokensSold = 0;

        initialized();
    }

    /**
    * @notice Buys tokens and snds to beneficiary.
    * @param beneficiary The new to mint to
    */
    function buyTokens(address beneficiary) public nonReentrant payable {
        uint256 weiAmount = msg.value;
        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
        require(weiAmount != 0, "Crowdsale: weiAmount is 0");

        uint256 tokens = weiAmount.mul(rate);
        tokenManager.mint(beneficiary, tokens);
        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
        vault.deposit.value(weiAmount);
    }

    /**
    * @notice Set the Token Manager to `_tokenManager`.
    * @param _tokenManager The new token manager address
    */
    function setTokenManager(address _tokenManager) external auth(SET_TOKEN_MANAGER_ROLE) {
        require(isContract(_tokenManager), "ERROR_ADDRESS_NOT_CONTRACT");

        tokenManager = TokenManager(_tokenManager);
        emit SetTokenManager(_tokenManager);
    }

    /**
    * @notice Set the Vault to `_vault`.
    * @param _vault The new vault address
    */
    function setVault(address _vault) external auth(SET_VAULT_ROLE) {
        vault = Vault(_vault);
        emit SetVault(_vault);
    }

    /**
    * @dev Convenience function for getting the Minted Token in a radspec string
    */
    function getToken() public returns (address) {
        return tokenManager.token();
    }
}
