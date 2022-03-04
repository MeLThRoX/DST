// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DST
{

    address private constant stable = 0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa; //dai
    address private constant volat = 0xc778417E063141139Fce010982780140Aa0cD5Ab; //weth

    address private admin;
    uint256 private currentID;

    struct Product 
    {
        uint256 ID;
        string name;
        uint256 pricePerUnit;
        string description;
        string pictureHash;
        uint256 soldUnits;
        string category;
    }

    Product[] private products;
    mapping(uint256 => uint256) private inventory;

    ERC20 usedToken;

    constructor(address _token)
    {
        admin = msg.sender;
        currentID = 0;
        usedToken = ERC20(_token);
    }

    function addInventory(uint256 _id, uint256 _amount)
    public
    {
        require(msg.sender == admin, "Only admin allowed to execute!");
        inventory[_id] += _amount;
    }


    function reduceInventory(uint256 _id, uint256 _amount) 
    public
    {
        require(msg.sender == admin, "Only admin allowed to execute!");
        require(inventory[_id] >= _amount, "Cant reduce more than currently available!");
        inventory[_id] -= _amount;
    }


    function changeAdmin(address _newAdmin) 
    public
    {
        require(msg.sender == admin, "Only admin allowed to execute!");
        admin = _newAdmin;
    }


    function createNewItemInInventoy(
        string calldata _category,
        string calldata _name,  
        uint256 _price, 
        uint256 _amount, 
        string calldata _description, 
        string calldata _pictureHash)
    public
    returns(bool)
    {
        require(msg.sender == admin, "Only admin allowed to execute!");
        Product memory neues = Product(currentID, _name, _price, _description,  _pictureHash, 0, _category);
        products.push(neues);

        inventory[currentID] = _amount;
        
        currentID += 1;

        return true;
    }

    
    function buy(uint256 _id, uint256 _amount) 
    public
    returns(bool)
    {
        require(inventory[_id] > _amount, "Not enought products in store!");
        uint256 totalPrice = getProductPrice(_id) * _amount;
        require(usedToken.allowance(msg.sender, address(this)) >= totalPrice, "Allowance is too low!");
        
        usedToken.transferFrom(msg.sender, address(this), _amount);
        inventory[_id] = inventory[_id] - _amount;
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


    function getProductFromID(uint256 _id) 
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
