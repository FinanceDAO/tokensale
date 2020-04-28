pragma solidity ^0.4.24;

import "@aragon/os/contracts/apps/AragonApp.sol";
import "@aragon/apps-vault/contracts/Vault.sol";
import "@aragon/apps-token-manager/contracts/TokenManager.sol";
import "@aragon/apps-shared-minime/contracts/MiniMeToken.sol";

contract TokenSale is AragonApp {
    using SafeMath for uint256;

    // ---------------------------------- Roles --------------------------------------------/
    bytes32 constant public SET_TOKEN_MANAGER_ROLE = keccak256("SET_TOKEN_MANAGER_ROLE");
    bytes32 constant public SET_VAULT_ROLE = keccak256("SET_VAULT_ROLE");


    // ---------------------------------- State --------------------------------------------/
    TokenManager public tokenManager;
    Vault public vault;

    // How many token units a buyer gets per wei.
    // So, if you are using a rate of 1 with 3 decimals called TKN. 1 wei will give you 1 unit, or 0.001 TOK.
    uint256 public rate;

    // Maximum Tokens that can be sold in wei
    uint256 public cap;

    // Actual tokens sold in wei
    uint256 public tokensSold;

    // Wei Raised
    uint256 public weiRaised;


    // --------------------------------- Events --------------------------------------------/
    event SetTokenManager(address tokenManager);
    event SetVault(address vault);
    event TokensPurchased(address purchaser, address beneficiary, uint256 value, uint256 amount);

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    /**
    * @notice Initialize TokenSale contract
    */
    function initialize(Vault _vault, TokenManager _tokenManager) external onlyInit {
        tokenManager = _tokenManager;
        vault = _vault;
        rate = 2;
        cap = 10000000000000000000000;
        weiRaised = 0;
        tokensSold = 0;

        initialized();
    }

    function buyTokens(address beneficiary) public nonReentrant payable {
        uint256 weiAmount = msg.value;
        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
        require(weiAmount != 0, "Crowdsale: weiAmount is 0");

        // calculate token amount to be created
        uint256 tokens = weiAmount.mul(rate);

        // update state
        weiRaised = weiRaised.add(weiAmount);

        // mint tokens
        tokenManager.mint(beneficiary, tokens);
        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);

        // send wei to vault
        vault.deposit.value(weiAmount)(ETH, weiAmount);

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

    function mint(uint256 _amount) external payable {
        tokenManager.mint(msg.sender, 100000000000000000);
    }

    // --------------------------------------------------- private --------------------------------


}
