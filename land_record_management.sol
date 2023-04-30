// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LandRecordManagement {
    
    // Data structures to store information
    
    struct Land {
    uint256 id;
    string location;
    address payable owner;
    uint256 price;
    bool isForSale;
    }

    
    struct GovernmentAuthority {
        address officer;
        bool hasAccess;
    }
    
    struct LegalProfessional {
        address lawyer;
        bool hasAccess;
    }
    
    struct RealEstateAgent {
        address agent;
        bool hasAccess;
    }
    
    struct Surveyor {
        address surveyor;
        bool hasAccess;
    }
    
    struct Notary {
        address notary;
        bool hasAccess;
    }
    
    // Mapping of data structures
    
    mapping(uint256 => Land) public lands;
    mapping(address => GovernmentAuthority) public governmentAuthorities;
    mapping(address => LegalProfessional) public legalProfessionals;
    mapping(address => RealEstateAgent) public realEstateAgents;
    mapping(address => Surveyor) public surveyors;
    mapping(address => Notary) public notaries;
    
    // Modifier to restrict access to authorized parties only
    
    modifier onlyAuthorized {
        require(
            governmentAuthorities[msg.sender].hasAccess ||
            legalProfessionals[msg.sender].hasAccess ||
            realEstateAgents[msg.sender].hasAccess ||
            surveyors[msg.sender].hasAccess ||
            notaries[msg.sender].hasAccess,
            "Unauthorized access!"
        );
        _;
    }
    
    // Land owner functions
    
    function registerLand(uint256 _id, string memory _location, uint256 _price) public {
        lands[_id] = Land(_id, _location, payable(msg.sender), _price, true);
    }
    
    function setLandForSale(uint256 _id, bool _isForSale) public {
        require(lands[_id].owner == msg.sender, "You are not the owner of this land!");
        lands[_id].isForSale = _isForSale;
    }
    
    // Government authority functions
    
    function addGovernmentAuthority(address _officer) public onlyAuthorized {
        governmentAuthorities[_officer] = GovernmentAuthority(_officer, true);
    }
    
    function removeGovernmentAuthority(address _officer) public onlyAuthorized {
        delete governmentAuthorities[_officer];
    }
    
    function updateLandPrice(uint256 _id, uint256 _price) public onlyAuthorized {
        lands[_id].price = _price;
    }
    
    // Legal professional functions
    
    function addLegalProfessional(address _lawyer) public onlyAuthorized {
        legalProfessionals[_lawyer] = LegalProfessional(_lawyer, true);
    }
    
    function removeLegalProfessional(address _lawyer) public onlyAuthorized {
        delete legalProfessionals[_lawyer];
    }
    
    // Real estate agent functions
    
    function addRealEstateAgent(address _agent) public onlyAuthorized {
        realEstateAgents[_agent] = RealEstateAgent(_agent, true);
    }
    
    function removeRealEstateAgent(address _agent) public onlyAuthorized {
        delete realEstateAgents[_agent];
    }
    
    function buyLand(uint256 _id) public payable {
        require(lands[_id].isForSale, "This land is not for sale!");
        require(msg.value == lands[_id].price, "Incorrect price!");
        lands[_id].owner.transfer(msg.value);
        lands[_id].owner = payable(msg.sender);
        lands[_id].isForSale = false;
    }
    
    // Surveyor functions
    
    function addSurveyor(address _surveyor) public onlyAuthorized {
    surveyors[_surveyor] = Surveyor(_surveyor, true);
    }

    function removeSurveyor(address _surveyor) public onlyAuthorized {
    delete surveyors[_surveyor];
    }

    function resolveBoundaryDispute(uint256 _id, string memory _location) public onlyAuthorized {
        require(keccak256(bytes(lands[_id].location)) != keccak256(bytes(_location)), "The location is the same as the current location!");
        lands[_id].location = _location;
    }

    // Notary functions

    function addNotary(address _notary) public onlyAuthorized {
        notaries[_notary] = Notary(_notary, true);
    }

    function removeNotary(address _notary) public onlyAuthorized {
        delete notaries[_notary];
    }

    // Main function to call the other functions in the correct order

    function transferOwnership(uint256 _id, address _buyer) public {
        require(lands[_id].owner == msg.sender, "You are not the owner of this land!");
        require(realEstateAgents[msg.sender].hasAccess, "You are not a real estate agent!");
        require(!lands[_id].isForSale, "This land is already for sale!");
        
        lands[_id].isForSale = true;
        
        // Buyer negotiates terms
        
        // Buyer attends closing
        
        lands[_id].owner = payable(_buyer);
        lands[_id].isForSale = false;
        
        // Buyer registers with government agencies
    }

}