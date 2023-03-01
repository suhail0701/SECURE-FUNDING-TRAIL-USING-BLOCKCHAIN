pragma solidity ^0.8.10;
pragma experimental ABIEncoderV2;


contract CampaignFactory {
    address[] public deployedCampaigns;
    string[] public pn;
    string[] public pd;

    function createCampaign(
        uint256 minimum,
        string memory project_name,
        string memory project_description
    ) public {
        address newCampaign = address(new Campaign(
            minimum,
            msg.sender,
            project_name,
            project_description
        ));
        deployedCampaigns.push(newCampaign);
        pn.push(project_name);
        pd.push(project_description);
    }

    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }

    function getCampaigns() public view returns (string[] memory) {
        return pn;
    }

    function getCampaigns1() public view returns (string[] memory) {
        return pd;
    }
}


contract Campaign {
    struct Request {
        string description;
        uint256 value;
        address recipient;
        bool complete;
        uint256 approvalCount;
        mapping(address => bool) approvals;
    }
   

    Request[] public requests;
    string pn;
    string pd;
    address public manager;
    uint256 public minimumContribution;
    mapping(address => bool) public approvers;
    uint256 public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor(
        uint256 minimum,
        address creator,
        string memory project_name,
        string memory project_description
    ) public {
        manager = creator;
        minimumContribution = minimum;
        pn = project_name;
        pd = project_description;
    }

    function contribute() public payable {
        require(msg.value > minimumContribution);

        approvers[msg.sender] = true;
        approversCount++;
    }

    uint numRequests;
    mapping (uint => Request) request;
    
    function createRequest (string memory description, uint value,
            address recipient) public{
                Request storage r = request[numRequests++];
                r.description = description;
                r.value = value;
                r.recipient = recipient;
                r.complete = false;
                r.approvalCount = 0;
            
        }

    function approveRequest(uint256 index) public {
        Request storage request = requests[index];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint256 index) public restricted {
        Request storage request = requests[index];

        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);

        payable(request.recipient).transfer(request.value);
        request.complete = true;
    }

    function getSummary()
        public
        view
        returns (uint256, uint256, uint256, uint256, address, string memory, string memory)
    {
        return (
            minimumContribution,
            address(this).balance,
            requests.length,
            approversCount,
            manager,
            pn,
            pd
        );
    }

    function getRequestsCount() public view returns (uint256) {
        return requests.length;
    }
}
