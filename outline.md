# Aragon Token Sale

## Problem
There is no easy way to do a token sale on Aragon outside of Aragon Fundraising. This sucks because AF kinda sucks. Idealy there would be a way to conduct a simple token sale at a fixed price

## Solution 
An Aragon app that accepts `DAI` and mints a DAO tokens at a fixed rate. The configurable paramaters should be
This should be a simple smart contract, that has permissions to mint tokens on a tokenmanager. It will send the donation to the DAOs agent or vault. It can also be setup with a ENS name so users can donate directly from their wallet. Additionaly 
a front end will be built leveragig toolkit

### State

- `RATE`:          the `DAI` to token rate
- `CAP`:           the maximum tokens to be minted
- `PERIOD`:        how long sale lasts
- `STATE`:         open or closed
- `TOKEN_MANAGER`: the token manager of DAOs Token
- `VAULT`:         the DAOs vaut

### Roles
- `SET_RATE_ROLE`
- `SET_CAP_ROLE`
- `SET_PERIOD_ROLE`
- `OPEN_SALE_ROLE`
- `CLOSE_SALE_ROLE`
- `SET_TOKEN_MANAGER_ROLE`
- `SET_VAULT_ROLE`

### Initialiser
```
initialize(
    TokenManager _tm,
    Vault _agent, 
    uint256 _rate,
    uint256 _duration,
    boolien _open,
)
```



