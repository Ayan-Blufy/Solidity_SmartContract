 pragma solidity >= 0.5.0 < 0.9.0;



 contract crowdfunding{


mapping(address=>uint) public contributers;
address public manager;
uint public minimumContribution;
uint public deadline;
uint public target;
uint public raisedAmount;
uint public noOfContributors;

struct Request{
    string description;
    address payable recipients;
    uint value;
    bool completed;
    uint noOfVoters;
    mapping(address=>bool) voters;
}

mapping(uint=>Request) public requests;
uint public numRequest;
constructor(uint _target,uint _deadline)
{
    target=_target;
    deadline=block.timestamp+_deadline;
    minimumContribution=100 wei;
    manager=msg.sender;

}

function sendEth() public payable {
    require(block.timestamp<deadline,"Deadline has passed");
    require(msg.value>=minimumContribution,"Minimum Contribution is not met");

    if(contributers[msg.sender]==0)
    {
        noOfContributors++;
    }
    contributers[msg.sender]+=msg.value;
    raisedAmount+=msg.value;

}

  function getBalance() view public returns(uint){
    return address(this).balance;
}


function getRefund() public {
   require(block.timestamp>deadline && raisedAmount<target,"You are not aligible");
require(contributers[msg.sender]>0);
address payable Contributor=payable(msg.sender);
Contributor.transfer(contributers[msg.sender]);
raisedAmount-=contributers[msg.sender];
contributers[msg.sender]=0;


}
modifier onlyManager(){
    require(msg.sender==manager,"Only manager can call this function");
    _;

}
function createRequest(string memory _description,address payable _recipient,uint _value) public onlyManager{


    Request storage newRequest=requests[numRequest];
    numRequest++;

    newRequest.description=_description;
    newRequest.recipients=_recipient;
    newRequest.value=_value;
    newRequest.completed=false;
    newRequest.noOfVoters=0;

}


function voteRequest(uint _requestNo)public{
require(contributers[msg.sender]>=minimumContribution,"You must a contributer");
Request storage thisRequest=requests[_requestNo];
require(thisRequest.voters[msg.sender]==false,"You have already voted");
thisRequest.voters[msg.sender]=true;
thisRequest.noOfVoters++;



}


function makePayment(uint _requestNo) public onlyManager{
    require(raisedAmount>=target);
Request storage thisRequest=requests[_requestNo];
require(thisRequest.completed==false,"This request is completed");
require(thisRequest.noOfVoters>noOfContributors/2);
thisRequest.recipients.transfer(thisRequest.value);
thisRequest.completed=true;
raisedAmount-=thisRequest.value;

}
 }