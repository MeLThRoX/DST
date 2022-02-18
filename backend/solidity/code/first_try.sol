// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract DST
{

    address private constant stable = 0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa; //dai
    address private constant volat = 0xc778417E063141139Fce010982780140Aa0cD5Ab; //weth

    address admin;
    uint256 private currentID;

    struct Product 
    {
        uint256 ID;
        string name;
        string cat;
        uint256 price;
        string description;
    }

    Product[] private products;

    mapping(uint256 => uint256) private Inventory;

    constructor()
    {
        admin = msg.sender;
        currentID = 0;
    }

    function transfer(address _token, uint256 _amount, address _customer) 
    public 
    payable 
    returns(bool)
    {
        return ERC20(_token).transferFrom(_customer, address(this), _amount);
    }

    function createNewItemInInventoy(string calldata _name, string calldata _cat, uint256 _price, uint256 _amount, string calldata _des)
    public
    payable 
    returns(bool)
    {
        Product memory neues = Product(currentID, _name, _cat, _price, _des );
        products.push(neues);
        Inventory[currentID] = _amount;
        currentID += 1;

        return true;
    }

    function buy(uint256 _id, uint256 _amount) 
    public 
    payable 
    returns(bool)
    {
        require(Inventory[_id] > _amount, "Das Produkt ist nicht in der gewuenschten Quantitaet verfuegbar!");
        //Inventory[_id] = Inventory[_id] - _amount;
        return transfer(stable, getProductPrice(_id), msg.sender);
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
        return Inventory[_id];
    }

    function getProductFromID(uint256 _id) public view returns(Product memory)
    {
        return products[_id];
    }

    function getProductPrice(uint256 _id) public view returns(uint256)
    {
        return products[_id].price;
    }

    function withdraw() public returns(bool)
    {

    }

    function adress() public view returns(address)
    {
        return address(this);
    }
}