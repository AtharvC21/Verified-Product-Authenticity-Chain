// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title Verified Product Authenticity Chain
 * @dev Smart contract to track and verify product authenticity on Core DAO
 */
contract ProductAuthenticity {
    address public owner;
    
    struct Product {
        string productId;
        string productName;
        string manufacturer;
        uint256 manufactureDate;
        bool isVerified;
        address verifier;
    }
    
    // Mapping from product ID to Product struct
    mapping(string => Product) public products;
    
    // Events
    event ProductRegistered(string productId, string productName, string manufacturer);
    event ProductVerified(string productId, address verifier);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @dev Register a new product in the authenticity chain
     * @param _productId Unique identifier for the product
     * @param _productName Name of the product
     * @param _manufacturer Name of the manufacturer
     */
    function registerProduct(
        string memory _productId, 
        string memory _productName, 
        string memory _manufacturer
    ) public {
        // Ensure product doesn't already exist
        require(bytes(products[_productId].productId).length == 0, "Product already registered");
        
        // Create new product
        Product memory newProduct = Product({
            productId: _productId,
            productName: _productName,
            manufacturer: _manufacturer,
            manufactureDate: block.timestamp,
            isVerified: false,
            verifier: address(0)
        });
        
        // Store product in mapping
        products[_productId] = newProduct;
        
        // Emit event
        emit ProductRegistered(_productId, _productName, _manufacturer);
    }
    
    /**
     * @dev Verify a product's authenticity
     * @param _productId ID of the product to verify
     */
    function verifyProduct(string memory _productId) public onlyOwner {
        // Ensure product exists
        require(bytes(products[_productId].productId).length != 0, "Product does not exist");
        // Ensure product is not already verified
        require(!products[_productId].isVerified, "Product already verified");
        
        // Update product verification status
        products[_productId].isVerified = true;
        products[_productId].verifier = msg.sender;
        
        // Emit event
        emit ProductVerified(_productId, msg.sender);
    }
    
    /**
     * @dev Check authenticity status of a product
     * @param _productId ID of the product to check
     * @return Product details including verification status
     */
    function checkAuthenticity(string memory _productId) public view returns (
        string memory productName,
        string memory manufacturer,
        uint256 manufactureDate,
        bool isVerified,
        address verifier
    ) {
        // Ensure product exists
        require(bytes(products[_productId].productId).length != 0, "Product does not exist");
        
        Product memory product = products[_productId];
        return (
            product.productName,
            product.manufacturer,
            product.manufactureDate,
            product.isVerified,
            product.verifier
        );
    }
}
