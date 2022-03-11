// SPDX-License-Identifier: GPL-3.0
        
pragma solidity >=0.4.22 <0.9.0;

// This import is automatically injected by Remix
import "remix_tests.sol"; 

// This import is required to use custom transaction context
// Although it may fail compilation in 'Solidity Compiler' plugin
// But it will work fine in 'Solidity Unit Testing' plugin
import "remix_accounts.sol";
import "./shop.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract ShopTesting {
    // instance of shop
    DST dst;

    function beforeAll() public {
        // new shop that uses weth on rinkeby, not relevant for testing
        dst = new DST(msg.sender, 0xc778417E063141139Fce010982780140Aa0cD5Ab);
    }

    
    function initialSetupIsCorrect() public
    {
        Assert.ok(dst.getProducts().length == 0, "Products is not empty");
        Assert.equal(msg.sender, dst.admin(), "Admin is not set correctly");
    }
    

    function addingAnItemWorks() public
    {
        uint256 id = dst.setNewItemInShop("TestCategory", "Testname", 100, 30, "Das ist ein Testitem", "TestHash");
        DST.Product memory setItem = dst.getProductAtID(id);
        DST.Product memory comparison = DST.Product(id, "TestCategory", "Testname", 100, "Das ist ein Testitem", "TestHash", 0); 
        Assert.equal(setItem.ID, comparison.ID, "Product-IDs are not the same");
        Assert.equal(setItem.name, comparison.name, "Product-names are not the same");
        Assert.equal(setItem.description, comparison.description, "Products-descriptions are not the same");
        // no need to test all attributes of the two structs
    }


    function productAttributesAfterBuying() public
    {
        // buy product, that was set in addingAnItemWorks function 
        dst.buy(0, 10);
        DST.Product memory current = dst.getProductAtID(0);
        Assert.equal(current.soldUnits, 10, "Bought units not registered correctly");
        Assert.equal(dst.getInventoryAtID(0), 20, "Inventory not updated correctly");
    }


    function addingToInventory() public
    {
        dst.addInventory(0, 20);
        Assert.equal(dst.getInventoryAtID(0), 40, "Inventory not updated correctly");
    }


    function removingFromInventory() public
    {
        dst.reduceInventory(0, 30);
        Assert.equal(dst.getInventoryAtID(0), 10, "Inventory not updated correctly");
    }

}
