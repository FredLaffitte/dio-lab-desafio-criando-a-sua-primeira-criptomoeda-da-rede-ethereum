// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20{
    //getters
    function totalSupply() external view returns(uint256);
    function balanceOf(address account)external view  returns(uint256);
    function allowance(address owner, address spender )external view returns (uint256 amount );  

    //functions
    function transfer(address recipient, uint256 amount)external returns (bool success );
    function approve(address spender, uint256 amount)external  returns (bool success );
    function transferFrom(address sender, address recipient, uint256 amount )external  returns (bool success );

    //events
    event Transfer(address indexed from , address indexed to, uint256 amount );
    event Approval(address indexed owner, address indexed spender, uint256 amount );
}  //end of interface

contract DIOToken is IERC20{ 
    string public constant name="DIOToken";
    string public constant symbol="DIO";  //token name 
    uint8 public constant decimals=18 ; //decimal places

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256))  allowances ; //mapping of allowance
    uint256 public totalSupply_ = 10 ether;

    constructor(){
        balances[msg.sender]=totalSupply_;

    }

    //implementing the interface  functions

    function totalSupply() public override view returns (uint256)  {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner)public override view  returns (uint256)   {
        return balances[tokenOwner];
    }

    function transfer(address recipient, uint256 numTokens)public override  returns (bool success){
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] -= numTokens;
        balances[recipient] += numTokens;
        emit Transfer(msg.sender, recipient, numTokens );  //emit transfer event
        return true ;  // return success
    }

    function approve(address spender, uint256 numTokens)public override  returns (bool success){
        allowances[msg.sender][spender] = numTokens;
        emit Approval(msg.sender, spender, numTokens );  //emit approval event 
        return true ;  //return success
     }  //end of approve

    //spender = delegate

    function allowance(address owner, address spender)public override  view  returns (uint256)   {  //allowance is a function in IERC20 interface 
        return allowances[owner][spender];  //return allowance of owner and spender
    }  //end of allowance

    function transferFrom(address owner, address buyer, uint256 numTokens)public override  returns (bool success){
        require((numTokens <= balances[owner]) && (numTokens <= allowances[owner][msg.sender])); //require the amount of tokens to be less than the balance of the sender and the allowance of the sender and the caller 
        balances[owner] -= numTokens ; //subtract the amount of tokens from the sender 
        balances[buyer] += numTokens ; //add the amount of tokens to the recipient 
        allowances[owner][msg.sender] -= numTokens ; //subtract the amount of tokens from the allowance of the sender 
        emit Transfer(owner, buyer, numTokens ); //emit the transfer event 
        emit Approval(owner, msg.sender, numTokens ); //emit the approval event 
        return true ; //return success
    }

} //end of contract  DIOToken  //end of interface