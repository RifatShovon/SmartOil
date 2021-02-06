pragma solidity 0.4.25;

contract OilDistribution{
    address myAddress;
    address driller_address = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address factory_address = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    address storage_address = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
    address pump_address = 0x5a2E8116e58884EcC159a403EE628f2634C2757f;
    
    
    // all the dates ensuring varifiability
    uint drilling_date;
    uint factory_dist_start_date;
    uint refinery_start_date;
    uint pump_start_date;
    
    string oilId;
    string oilName;
    
    //prices in different level of distribution
    uint drill_price;
    uint factory_price;
    uint storage_price;
    uint pump_price;
    
    
    // traces of quantities sold in different levels of distribution
    
    uint driller_sold_amount;
    uint factory_sold_amount;
    uint storage_sold_amount;
    uint pump_sold_amount;
    
    enum PresentTrace {Driller, Factory, Storage, Pump}
    PresentTrace public trace;
    
    
    //event
    event InitiateDist(address ad, string  masg);
    event FactoryDistribution(address ad, string masg);
    event StorageWholesell(address ad, string masg);
    event PumpOilSold(address ad, string masg);
    
    
    //modifiers
    
    modifier onlyOwner(){
        require(msg.sender == myAddress);
        _;
    }
    
    modifier onlyDriller(){
        require(msg.sender == driller_address);
        _;
    }
    
    
    modifier onlyFactory(){
        require(msg.sender == factory_address);
        _;
    }
    
    modifier onlyStorage(){
        require(msg.sender == storage_address);
        _;
    }
    
    // constructor and methods
    constructor() public{
        myAddress = msg.sender;
    }
    
    
    
    // distribution starting from driller
    function readyToFactory(
        string memory name,
        string memory id,
        uint price,
        uint quant) public onlyDriller{
        
        trace = PresentTrace.Driller;
        drilling_date = block.timestamp;
        oilName = name;
        oilId = id;
        drill_price = price;
        driller_sold_amount = quant;
        
        emit InitiateDist(driller_address, "Crude Oil is Ready to go to the Factory.");
        
    }
    
    
    // factory information
    function readyToStorage(uint fact_quant, uint fact_price) public onlyFactory{
        
        factory_dist_start_date = block.timestamp;
        factory_price = fact_price;
        factory_sold_amount = fact_quant;
        
        trace = PresentTrace.Factory;
        emit FactoryDistribution(factory_address, "Oil is ready to distribute in Oil Storage.");
    }
    
    
    // storage information
    function oilInOilStorage(uint stor_price, uint stor_quant) public onlyStorage{
        
        refinery_start_date = block.timestamp;
        
        storage_sold_amount = stor_quant;
        storage_price = stor_price;
        trace = PresentTrace.Storage;
        emit StorageWholesell(storage_address, "Oil is now in Oil Storage."); 
    }
    
    // Oil pump retail sell information
    function pumpSoldOil(uint pum_price, uint pum_quant)public{
        
        pump_start_date = block.timestamp;
        pump_price = pum_price;
        pump_sold_amount = pum_quant;
        
        emit PumpOilSold(pump_address, "Oil pump sold Oil as a Retailer.");
        trace = PresentTrace.Pump;
    }
    
}