// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DST
{

    //address private constant stable = 0x5592EC0cfb4dbc12D3aB100b257153436a1f0FEa; //dai
    //address private constant volat = 0xc778417E063141139Fce010982780140Aa0cD5Ab; //weth

    address private admin;
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

    struct inputProduct 
    {
        string category;
        string name;
        uint256 pricePerUnit;
        uint256 amount;  
        string description;
        string pictureHash;
    }

    struct Cart
    {
        uint256 productID;
        uint256 amount;
    }

    struct Order
    {
        Cart[] cart;
        uint256 totalValueOfOrder;
        string encInfo;
    }

    
    uint256[] private Test;
    Order[] private orderList;
    Product[] private products;
    mapping(uint256 => uint256) private inventory;

    ERC20 usedToken;

    constructor()
    {
        admin = msg.sender;
        currentID = 0;
        usedToken = ERC20(0xc778417E063141139Fce010982780140Aa0cD5Ab);
        //usedToken = ERC20(_token);
    }


/*
----- Management functions
*/
    function addInventory(uint256 _id, uint256 _amount)
    public
    {
        require(isAdmin(), "Only admin allowed to execute!");
        inventory[_id] += _amount;
    }


    function reduceInventory(uint256 _id, uint256 _amount) 
    public
    {
        require(isAdmin(), "Only admin allowed to execute!");
        require(inventory[_id] >= _amount, "Cant reduce more than currently available!");
        inventory[_id] -= _amount;
    }


    function changeAdmin(address _newAdmin) 
    public
    {
        require(isAdmin(), "Only admin allowed to execute!");
        admin = _newAdmin;
    }

    // Price in wei
    function changePrice(uint256 _id, uint256 _newPrice)
    public
    {
        require(isAdmin(), "Only admin allowed to execute!");
        Product memory current = getProductAtID(_id);
        current.pricePerUnit = _newPrice;
        products[_id] = current;
    }


    function createItems( inputProduct[] calldata input) public 
    {
        require(isAdmin(), "Only admin allowed to execute!");

        for (uint i=0; i<input.length; i++) {
            Product memory neues = Product(currentID,
                input[i].category,  
                input[i].name, 
                input[i].pricePerUnit, 
                input[i].description,  
                input[i].pictureHash, 
                0);
            products.push(neues);
            inventory[currentID] = input[i].amount;
            currentID += 1;
        }
    }


/*
----- Order-Related
*/

    function buyCart(Cart[] calldata input, string calldata encInfo)
    public
    {
        // not sure, if this is the best way
        bool readyToTransfer = true;
        uint256 totalPrice = 0;

        for (uint i=0; i<input.length; i++)
        {
            totalPrice += (getProductPrice(input[i].productID) * input[i].amount);
            if (inventory[input[i].productID] < input[i].amount)
            {
                readyToTransfer = false;
            }
        }

        require(usedToken.allowance(msg.sender, address(this)) >= totalPrice, "Allowance is too low!");
        if (readyToTransfer) 
        {
            for (uint i=0; i<input.length; i++)
            {
                //update-product info in inventory
                Product memory current = getProductAtID(input[i].productID);
                current.soldUnits += input[i].amount;
                products[input[i].productID] = current;
               
                inventory[input[i].productID] = inventory[input[i].productID] - input[i].amount;
            }

            //transfer token
            usedToken.transferFrom(msg.sender, address(this), totalPrice); 
            
            /*
            Instead of: orderList.push(Order(input,totalPrice,encInfo));
            We use the following:
            */
            Order memory newOrder = orderList.push();
            newOrder.cart = input;
            newOrder.totalValueOfOrder = totalPrice;
            newOrder.encInfo = encInfo;
        }
    }
    
    function pushOrderTest(Cart[] memory input, uint256 price, string calldata encInfo)
    public
    {
        
        Order storage newOrder = orderList.push();
        newOrder.encInfo = encInfo;
        newOrder.totalValueOfOrder = price;

        for (uint256 i = 0; i < input.length; i += 1)
        {
            Cart memory tmp = Cart(input[i].productID,input[i].amount);
            newOrder.cart.push(tmp);
        }

    }

    /*

    function buy(uint256 _id, uint256 _amount) 
    private
    returns(bool)
    {
        // check if all requirements for transfer are met
        require(inventory[_id] > _amount, "Not enought products in store!");
        uint256 totalPrice = getProductPrice(_id) * _amount;
        require(usedToken.allowance(msg.sender, address(this)) >= totalPrice, "Allowance is too low!");
        
        // transfer total price from customer to contract
        usedToken.transferFrom(msg.sender, address(this), _amount);
        inventory[_id] = inventory[_id] - _amount;

        // set new product info within contract
        Product memory current = getProductAtID(_id);
        current.soldUnits += _amount;
        products[_id] = current;

        return true;
    }
    */
    
    function withdraw(address _receiver, uint256 _amount) 
    public
    {
        require(isAdmin() , "Only admin allowed to execute!");
        require(usedToken.balanceOf(address(this)) >= _amount, "Not enought token in contract");
        usedToken.transfer(_receiver, _amount);
    }


    function getAllOrders()
    public
    view
    returns(Order[] memory)
    {
        require(isAdmin() , "Only admin allowed to execute!");
        return orderList;
    }

    /* TODO
    getSomeOfTheOrder - only get split of ordered items, maybe last 24 hours, or orders, that have not been checked for
    */

/*
----- Getter functions
*/

    function isAdmin()
    public
    view
    returns(bool)
    {
        return (msg.sender == admin);
    }

    function getSoldUnits(uint256 _id)
    public
    view
    returns(uint256)
    {
        return getProductAtID(_id).soldUnits;
    }

    function getTokenName()
    public
    pure
    returns(string memory)
    {
        return "WETH";
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
        // no need to check if _id exists in inventory. key-value pairs give automatic feedback
        return inventory[_id];
    }


    function getProductAtID(uint256 _id) 
    public 
    view 
    returns(Product memory)
    {
        require(products.length > _id, "Product does not exist");
        return products[_id];
    }


    function getProductPrice(uint256 _id) 
    public 
    view 
    returns(uint256)
    {
        return getProductAtID(_id).pricePerUnit;
    }


    function getBalance()
    public
    view
    returns(uint256)
    {
        return usedToken.balanceOf(address(this));
    }


}
