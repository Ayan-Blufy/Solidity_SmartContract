 pragma solidity >= 0.5.0 < 0.9.0;


 contract Lottery{
 address public manager;

    address payable [] public participants;

  

  constructor(){
      manager=msg.sender;
  }

  receive() external payable{
      require(msg.value==2 ether);
      participants.push(payable(msg.sender));
  }

  function getBalance() view public returns(uint){
      require(msg.sender==manager);
      return address(this).balance;
  }

  function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }

    function selectWinner() public {
        uint r=random();
        uint k=r%participants.length;
        address payable winner;
        winner=participants[k];

        winner.transfer(getBalance());
         participants=new address payable[](0);


    }

 }