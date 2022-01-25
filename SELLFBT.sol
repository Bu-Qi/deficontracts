// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

interface  iFBT {
    function transfer_fee(address _from,uint256 _value) external view returns (uint256 fee);
    function balanceOf(address owner) external view returns (uint); 
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

contract SELLFBT {
    address public FBT=0x5bA29286A4A4b3a51Afa37B1e9F99bB1996dFD13;
    address public USDT=0xDF0e293CC3c7bA051763FF6b026DA0853D446E38;
    address public DAO=0xa108C775550f4ef3a996f1759C0Bcc79A38B5827;
    address payable public owner;
    uint256 public sellFBTprice=3350;
     constructor() {
        owner = payable(msg.sender);
    }


    function sellFBT() public{
        require(!_isContract(msg.sender), "cannot be a contract");
        uint256 balance = iFBT(FBT).balanceOf(msg.sender);
        uint256 FBTfee= iFBT(FBT).transfer_fee(msg.sender,balance);
        uint256 sellFBTamount= balance-FBTfee;
        uint256 getUSDTamount=sellFBTamount*sellFBTprice;
        TransferHelper.safeTransferFrom(FBT, msg.sender, DAO,sellFBTamount );
        TransferHelper.safeTransfer(USDT,msg.sender,getUSDTamount);
    }
    function withdraw(uint amount) public {
        require(msg.sender == owner);
        owner.transfer(amount);
    }
    function withdrawToken(address token,uint256 amount) public {
        require(msg.sender == owner);
        TransferHelper.safeTransfer(token,msg.sender,amount);
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
        DAO = new_DAO;
    }
    function setFBTprice(uint256 newprice) public {
        require(msg.sender == owner);
        sellFBTprice = newprice ;
    }
}
