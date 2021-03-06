// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
	The code of original DST needs to be edited in order for some tests to work.
		- Access-control is removed
		- Code that has to do with transfering token is removed (commented out)
*/

contract DST
{

    address private constant stable = 0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa; //dai
    address private constant volat = 0xc778417E063141139Fce010982780140Aa0cD5Ab; //weth

    address public admin;
    uint256 private currentID;

    struct Product 
    {
        uint256 ID;
        string category;
        string name;
        uint256 pricePerUnit;
        string description;
        string pictureHash;
        uint256 soldUnits;  
    }

    Product[] public products;
    mapping(uint256 => uint256) private inventory;

    ERC20 usedToken;

    constructor(address _admin_debug, address _token)
    {
        //admin = msg.sender;
        //For testing:
        admin = _admin_debug;
        
        currentID = 0;
        usedToken = ERC20(_token);
    }

    function addInventory(uint256 _id, uint256 _amount)
    public
    {
        //require(msg.sender == admin, "Only admin allowed to execute!");
        inventory[_id] += _amount;
    }


    function reduceInventory(uint256 _id, uint256 _amount) 
    public
    {
        //require(msg.sender == admin, "Only admin allowed to execute!");
        require(inventory[_id] >= _amount, "Cant reduce more than currently available!");
        inventory[_id] -= _amount;
    }


    function changeAdmin(address _newAdmin) 
    public
    {
        //require(msg.sender == admin, "Only admin allowed to execute!");
        admin = _newAdmin;
    }


    function setNewItemInShop(
        string calldata _category,
        string calldata _name,  
        uint256 _price, 
        uint256 _amount, 
        string calldata _description, 
        string calldata _pictureHash)
    public
    returns(uint256)
    {
        //For testing-reasons
        //require(msg.sender == admin, "Only admin allowed to execute!");
        Product memory neues = Product(currentID, _category,  _name, _price, _description,  _pictureHash, 0);
        products.push(neues);

        inventory[currentID] = _amount;
        
        currentID += 1;

        return currentID - 1;
    }

    
    function buy(uint256 _id, uint256 _amount) 
    public
    returns(bool)
    {
        // check if all requirements for transfer are met
        //require(inventory[_id] > _amount, "Not enought products in store!");
        //uint256 totalPrice = getProductPrice(_id) * _amount;
        //require(usedToken.allowance(msg.sender, address(this)) >= totalPrice, "Allowance is too low!");
        
        // transfer total price from customer to contract
        //usedToken.transferFrom(msg.sender, address(this), _amount);
        inventory[_id] = inventory[_id] - _amount;

        // set new product info within contract
        Product memory current = products[_id];
        current.soldUnits += _amount;
        products[_id] = current;

        return true;
    }


    function getProducts() 
    public 
    view 
    returns(Product[] memory)
    {
        return products;
    }


    function getInventoryAtID(uint256 _id) 
    public 
    view 
    returns(uint256)
    {
        return inventory[_id];
    }


    function getProductAtID(uint256 _id) 
    public 
    view 
    returns(Product memory)
    {
        return products[_id];
    }


    function getProductPrice(uint256 _id) 
    public 
    view 
    returns(uint256)
    {
        return products[_id].pricePerUnit;
    }


    function withdraw(address _receiver, uint256 _amount) 
    public
    {
        require(msg.sender == admin, "Only admin allowed to execute!");
        require(usedToken.balanceOf(address(this)) >= _amount, "Not enought token in contract");
        usedToken.transfer(_receiver, _amount);
    }
}
