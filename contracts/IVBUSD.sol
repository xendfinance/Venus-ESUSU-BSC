pragma solidity 0.6.6;

import './IERC20.sol';

/*
    This interface is for the Venus BUSD Shares contract
*/



interface IVBUSD is IERC20{
    
    function redeem(uint256 _shares) external returns (uint256);
    function mint(uint256 _amount) external returns (uint256);
    function getCash() external view returns (uint256);
    function totalBorrows() external view returns (uint256);
    function totalReserves() external view returns (uint256);

    
}