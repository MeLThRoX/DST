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
    DST dst;

    /*
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
    */

    function beforeAll() public {
        // new shop that uses weth on rinkeby
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

    }

/*
    function checkSuccess() public {
        // Use 'Assert' methods: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        Assert.ok(2 == 2, 'should be true');
        Assert.greaterThan(uint(2), uint(1), "2 should be greater than to 1");
        Assert.lesserThan(uint(2), uint(3), "2 should be lesser than to 3");
    }

    function checkSuccess2() public pure returns (bool) {
        // Use the return value (true or false) to test the contract
        return true;
    }
    
    function checkFailure() public {
        Assert.notEqual(uint(1), uint(1), "1 should not be equal to 1");
    }

    /// Custom Transaction Context: https://remix-ide.readthedocs.io/en/latest/unittesting.html#customization
    /// #sender: account-1
    /// #value: 100
    function checkSenderAndValue() public payable {
        // account index varies 0-9, value is in wei
        Assert.equal(msg.sender, TestsAccounts.getAccount(1), "Invalid sender");
        Assert.equal(msg.value, 100, "Invalid value");
    }
    */
}
    
