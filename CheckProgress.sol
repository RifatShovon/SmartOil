pragma solidity 0.4.25;

contract CheckProgress{
    
    address myAddress;
    string oilName;
    string oilID;
    uint accurateHum;
    uint amount;
    uint totalPrice;
    uint accurateTemp;
    uint accuratePress;
    address dataAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint storageDate;

    enum TempStage {Accurate, Higher, Lower}
    TempStage public TempValue;
    enum HumidityStage {Accurate, Higher, Lower}
    HumidityStage public HumValue;
    enum pressureStage {Accurate, Higher, Lower}
    pressureStage public PressValue;
    enum ViolationType{None, Temperature, Humidity, Pressure}
    ViolationType public VioType;
    
    constructor() public
    {
        myAddress = msg.sender;
        storageDate = block.timestamp;
        TempValue = TempStage.Accurate;
        HumValue = HumidityStage.Accurate;
        PressValue = pressureStage.Accurate;
        VioType = ViolationType.None;
    }
    
    modifier Self()
    {
        require(msg.sender == myAddress);
        _;
    }
    
    modifier Checker()
    {
        require(msg.sender == dataAddress);
        _;
    }
    
    event oilAdded(address addr, string  msg);
    event TemperatureViolation(address addr, string msg);
    event HummidityViolation(address addr, string msg);
    event PressureViolation(address addr, string msg);
    
    
    // adding seed to the storage
    function EnterOil (string memory name, string memory oil_id, uint amt, uint price, uint actualTemp, uint actualHum, uint actualPress) public Self
    {
        oilName = name;
        oilID = oil_id;
        amount = amt;
        totalPrice = price;
        accurateTemp = actualTemp;
        accurateHum = actualHum;
        accuratePress = actualPress;
    }

    function CheckTemperature (uint value) public Checker returns (string memory)
    {
        if(value > accurateTemp)
        {
            OccuredViolation(ViolationType.Temperature, 2);
            return "Current temperature is very HIGH";
        }
        else if(value < accurateTemp)
        {
            OccuredViolation(ViolationType.Temperature, 1);
            return "Current temperature is very LOW";
        }
        else
        {
            OccuredViolation(ViolationType.Temperature, 0);
            return "Current temperature is ACCURATE";
        }
    }

    function CheckHumidity(uint value) public Checker returns(string memory)
    {
        if(value > accurateHum)
        {
            OccuredViolation(ViolationType.Humidity, 2);
            return "Current humidity is very HIGH";
        }
        else if(value < accurateTemp)
        {
            OccuredViolation(ViolationType.Humidity, 1);
            return "Current humidity is very LOW";
        }
        else
        {
            OccuredViolation(ViolationType.Humidity, 0);
            return "Current humidity is ACCURATE";
        }
    }
    
    function CheckPressure (uint value) public Checker returns(string memory)
    {
        if(value > accuratePress)
        {
            OccuredViolation(ViolationType.Pressure, 2);
            return "Current Pressure is very HIGH";
        }
        else if(value < accuratePress)
        {
            OccuredViolation(ViolationType.Pressure, 1);
            return "Current Pressure is very LOW";
        }
        else
        {
            OccuredViolation(ViolationType.Pressure, 0);
            return "Current Pressure is ACCURATE";
        }
    }
    
    function OccuredViolation(ViolationType vio, int category) internal Checker
    { 
        if(vio == ViolationType.Temperature)
        {
            if(category == 2)
            {
                TempValue = TempStage.Higher;
                VioType = ViolationType.Temperature;
                emit TemperatureViolation(dataAddress, "Higher Temparature");  
            }
            else if(category == 1)
            {
                TempValue = TempStage.Lower;
                VioType = ViolationType.Temperature;
                emit TemperatureViolation(dataAddress, "Lower Temparature");
            }
            else if(category == 0)
            {
                TempValue = TempStage.Accurate;
                VioType = ViolationType.None;
                emit TemperatureViolation(dataAddress, "Accurate Temparature");
            }
        }
        else if(vio == ViolationType.Humidity)
        {
            if(category == 2)
            {
                HumValue = HumidityStage.Higher;
                VioType = ViolationType.Humidity;
                emit HummidityViolation(dataAddress, "Higher Hummidity"); 
            }
            else if(category == 1)
            {
                HumValue = HumidityStage.Lower;
                VioType = ViolationType.Humidity;
                emit HummidityViolation(dataAddress, "Lower Hummidity");
            }
            else if(category == 0)
            {
                HumValue = HumidityStage.Accurate;
                VioType = ViolationType.None;
                emit HummidityViolation(dataAddress, "Accurate Hummidity");
            }
            
        }
        
        
        else if(vio == ViolationType.Pressure)
        {
            if(category == 2)
            {
                PressValue = pressureStage.Higher;
                VioType = ViolationType.Pressure;
                emit PressureViolation(dataAddress, "Higher Pressure"); 
            }
            else if(category == 1)
            {
                PressValue = pressureStage.Lower;
                VioType = ViolationType.Pressure;
                emit PressureViolation(dataAddress, "Lower Pressure");
            }
            else if(category == 0)
            {
                PressValue = pressureStage.Accurate;
                VioType = ViolationType.None;
                emit PressureViolation(dataAddress, "Accurate Pressure");
            }
            
        }
        
    }
}