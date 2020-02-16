pragma solidity ^0.4.25; 

contract CampaignProject { 
    
    struct NameTopicp{
        string nametopic;
    }
    
    struct Count {
        uint256 countAllProject;
    }
    struct Getallprojectacc {
        address[] deployedproject;
    }
    address my_address;
    address[] public deployedCampaigns; 
    //mapping address with struct for using value in it
    mapping(address => NameTopicp) public nameTopic ;
    mapping(address => Getallprojectacc) allprojectacc ;
    mapping(address => Count) public countStruct;
    uint256 counts;
    
    //create project (Connect)
    function createProject(string memory ProjectName,string memory Owner ,uint Budget , string memory Desciption,string memory Date,address[] Partner,uint Status) public { 
        address newCampaign = new Project(ProjectName,Owner,Budget,Desciption,Date,Partner,msg.sender,Status);
        //push data to []adress
        deployedCampaigns.push(newCampaign); 
        var x = nameTopic[newCampaign];
        x.nametopic = ProjectName;
        //counting project of user 
        countStruct[msg.sender].countAllProject += 1;
        allprojectacc[msg.sender].deployedproject.push(newCampaign);
    }
    
    //get all deployed campaigns 
    function getDeployedCampaigns() public view returns (address[]) { 
        return deployedCampaigns; 
    } 
    
    //get project name of user by address
    function getProjectNameByAdr(address adr) public view returns(string){
        return nameTopic[adr].nametopic;
    }
    
    //get number of project by user's address
    function getProjectNumberByAdr() public view returns (uint256){
        return countStruct[msg.sender].countAllProject;
    }
    //get contract address of user's project
    function getAllProjectByAdr() public view returns (address[]){
        return allprojectacc[msg.sender].deployedproject;
    }
    
} 

contract Project {
    
    struct ValueStruct {
        uint money;
    }
    
    uint256 defaultcounts=0;
    uint public budget;
    address public creatorAddress;      
    string public projectName;
    string public owner;
    string public description;
    string public date;
    uint status;
    address[] public partner;
    uint totalmoney;
    address[] public deployedProject;
    address[] public FundingAccounts;
    address public my_address;
    
    uint public investerMoney;
    uint public fixMoney=10000;

    mapping(address => ValueStruct) public valueStructs;
    
    //declear enum var for state of processing's project 
    enum State { Start, Funding, Ended }
	State public state;

    //receive data and parse attr
	constructor(string memory ProjectName,string memory Owner ,uint Budget , string memory Desciption,string memory Date,address[] Partner,address sender,uint Status) public {
        creatorAddress = sender;
        projectName = ProjectName;
        owner = Owner;
        budget = Budget;
        description = Desciption;
        date = Date;
        partner = Partner;
        status = Status;
    }
    //using for only project's creater can do it 
	modifier onlyCreator() {
		require(msg.sender == creatorAddress);
		_;
	}
    
	modifier inState(State _state) {
		require(state == _state);
		_;
	}
    
    //set money in adr (hardcode every user have 1000)
    function ValueSetter() public {
        my_address = msg.sender;
        valueStructs[msg.sender].money= fixMoney;
    }

    //start project and change state (only creater project)
    function startFunding()public inState(State.Start) onlyCreator{
        state = State.Funding;     
    }
    
    //do funding and check case of payment 
    function doFunding(uint amount) public inState(State.Funding){
        if(totalmoney<budget && amount>=budget * 5 / 100 && amount<budget * 50 / 100 ){
            valueStructs[msg.sender].money = valueStructs[msg.sender].money-amount;
            totalmoney += amount;
        }
        //push investor's address to struct
        address newFundingAcc = msg.sender;
        FundingAccounts.push(newFundingAcc);
    }
    
    //get list of invester's account
    function getAllinvestorAcc() public view returns (address[]) {
        return FundingAccounts;
    }
    
    //get invvestor's account using index
    function selectInvestorAcc(uint x) public view returns (address) {
        return FundingAccounts[x];
    }
    
    //get total money of project
    function getTotalMoney() public view returns(uint){
        return totalmoney;
        
    }
    
    //get invester's money
    function getInvestorMoney() public view returns(uint256){
        return valueStructs[msg.sender].money;
    }
    
    //end funding and changes state(only creater project)
    function endFunding() public inState(State.Funding) onlyCreator 
    {
        state = State.Ended;
        
    }
    
    //create proposal of project (only creater project)
    function createProposal() public inState(State.Ended) onlyCreator{
        //check project's user that was good or not 
        if (totalmoney == budget) {
            address newProposal = new Proposal(projectName,owner ,budget ,description, date,FundingAccounts,status = 1 ,msg.sender);
            deployedProject.push(newProposal); 
        }
        else if(totalmoney != budget) {
            address newEjectProposal = new Proposal(projectName,owner ,budget ,description, date,FundingAccounts,status = 2, msg.sender);
            deployedProject.push(newEjectProposal);
        }
    }
    
    //get all deployed proposal 
    function getDeployedProposal() public view returns (address[]) { 
        return deployedProject; 
    } 
    
    //get proposal by index
    function selectDeployedProposal(uint x ) public view returns (address) { 
        return deployedProject[x]; 
    }

}

contract Proposal{
    uint public budget;
    address public creatorAddress;      
    string public projectName;
    string public owner;
    string public description;
    string public date;
    uint public status;
    uint public Goodproposal;
    uint public Badproposal;
    uint public Allproposal;
    uint public Percent;

    uint256 public funding;
    address[] public partner;
    
    constructor(string memory ProjectName,string memory Owner ,uint Budget , string memory Desciption,string memory Date,address[] Partner,uint Status,address sender) public {
        creatorAddress = sender;
        projectName = ProjectName;
        owner = Owner;
        budget = Budget;
        description = Desciption;
        date = Date;
        partner = Partner;
        status =Status;

    }
    
    function getCreatorAddress() public view returns(address){
        return creatorAddress;
    }
    
    function getProjectName() public view returns(string){
        return projectName;
    }
    
    function getOwner() public view returns(string){
        return owner;
    }
    
    function getBudget() public view returns(uint){
        return budget;
    }
    
    function getDesciption() public view returns(string){
        return description;
    }
    
    function getDate() public view returns(string){
        return date;
    }
    
    function getPartner() public view returns(address[]){
        return partner;
    }
    //check status' proposal and count it 
    function countProposal() public{
        if(status==1){
            Goodproposal ++;
        }Badproposal ++;
    }
    
    function getGoodprop() public view returns (uint){
        return Goodproposal;
    }
    
    function getBadprop() public view returns (uint){
        return Badproposal;
    }
    //example analystic of user's histrory that was made it 
    function calculatePercent() public view returns (uint){
        Allproposal = Goodproposal+Badproposal;
        Percent = Goodproposal/Allproposal;
        return Percent;
    }
    
}