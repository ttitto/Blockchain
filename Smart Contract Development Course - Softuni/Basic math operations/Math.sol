pragma solidity ^0.4.19;
import "browser/SafeMath.sol";

contract Math {
    using SafeMath for uint256;
    
    uint256 private first;
    
    function Math() public{
        first = 0;
    }
    
    function add( uint256 secondAddend) public payable{
        first = first.add(secondAddend);
    }
    
    function sub( uint256 subtrahend) public payable{
        first = first.sub(subtrahend);
    }
    
    function multiply(uint256 secondMultiplier) public payable{
        first = first.mul(secondMultiplier);
    }
    
    function divide(uint256 divisor ) public payable {
         first = first.div(divisor);
    }
    
    function pow( uint256 power) public payable{
        uint256 powResult = first ** power;
        assert(sqrt(powResult) == first);
        first = powResult;
    }
    
    function divisionRemainder(uint256 divisor) public payable{
        first = first % divisor;
    }
    
    function get() public view returns(uint256){
        return first;
    }
    
    function reset() public payable {
        first = 0;
    }
    
    /**
     * @dev Babylonian Method of finding the square root
    */
    function sqrt(uint256 x) internal pure returns (uint256 y) {
        y = x;
        uint256 z = (x + 1) / 2;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}