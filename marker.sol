// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

interface  iBT  {
    function transfer_fee(address _from,uint256 _value) external view returns (uint256 fee);
    function balanceOf(address owner) external view returns (uint); 
    function power(address owner) external view returns (uint256);

}

library TransferHelper {
    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }
}

contract qbf_market {
    address public USDT=0xDF0e293CC3c7bA051763FF6b026DA0853D446E38;
    address public BT=0xB1732A0907Cb5ba0fa0bdD37c9686030907B575A;
    address payable public owner;
    address public DAO=0xA615e04e976471B2a9f2d90A2ebde3EbBEb4a366;
    mapping (address => uint256) public last_buy;//用户上次买入时间
    uint256  public price=500;
    uint256  public maxamount=150*1e3;
    uint256 public cooldown=600;//冷却时间
    mapping (address => uint256) public limitamount;
    constructor() {
    owner = payable(msg.sender);
    }

    function BUY (uint256 amount ) public{
        require(!_isContract(msg.sender), "cannot be a contract");
        require(amount<=maxamount,"too much");
        require(block.timestamp - last_buy[msg.sender] >= cooldown);
        uint256 balance = iBT(USDT).balanceOf(msg.sender);
        uint256 usdt1=amount*price*87/100;
        uint256 usdt2=amount*price*13/100;
        TransferHelper.safeTransfer(BT,msg.sender,amount);
        TransferHelper.safeTransferFrom(USDT, msg.sender, address(this), usdt1);
        TransferHelper.safeTransferFrom(USDT, msg.sender, DAO, usdt2);
        limitamount[msg.sender] += usdt1;
        last_buy[msg.sender]=block.timestamp;
    }

    function SELL (uint256 amount) public{
        require(!_isContract(msg.sender), "cannot be a contract");
        require(limitamount[msg.sender] >= amount);
        uint256 ipower=iBT(BT).power(msg.sender);
        require(ipower>=500);
        uint256 getUSDTamount=amount*price;
        TransferHelper.safeTransferFrom(BT, msg.sender, address(this),amount);
        TransferHelper.safeTransfer(USDT,msg.sender,getUSDTamount);
        limitamount[msg.sender] -= getUSDTamount;
    }
    
    function withdraw(uint amount) public {
        require(msg.sender == owner);
        owner.transfer(amount);
    }
    function withdrawToken(address token,uint256 amount) public {
        require(msg.sender == owner);
        TransferHelper.safeTransfer(token,msg.sender,amount);
    }
    receive() payable external {
    }
        // 是否合约地址
    function _isContract(address _addr) private view returns (bool ok) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
    function setOwner(address payable new_owner) public {
        require(msg.sender == owner);
        owner = new_owner;
        
    }
    function setDAO(address new_DAO) public {
        require(msg.sender == owner);
        DAO= new_DAO ;
    }
  
    function setprice(uint256 newprice) public {
        require(msg.sender == owner);
        price = newprice ;
    }

    function setmaxamount(uint256 _maxamount) public {
        require(msg.sender == owner);
        maxamount=_maxamount ;
    }

    function setcooldown(uint256 _time) public {
        require(msg.sender == owner);
       cooldown=_time ;
    }
}
