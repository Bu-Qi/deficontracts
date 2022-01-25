// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}
contract  SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
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
contract FBTdividend is  SafeMath {
    address payable public owner;
    address public FBT = 0x5bA29286A4A4b3a51Afa37B1e9F99bB1996dFD13;
    uint8 public kolamount=0;
    uint8 public kol1amount=0;
    uint8 public kol2amount=0;
    uint8 public kol3amount=0;
    uint8 public kol4amount=0;
    uint8 public kol=10;
    uint8 public kol1=10;
    uint8 public kol2=10;
    uint8 public kol3=10;
    uint8 public kol4=10;
    uint256 public total=SafeMath.add(SafeMath.add(SafeMath.add(SafeMath.add(kol,kol1),kol2),kol3),kol4);
    mapping (address => bool) public iskol;
    mapping (address => bool) public iskol1;
    mapping (address => bool) public iskol2;
    mapping (address => bool) public iskol3;
    mapping (address => bool) public iskol4;
    bool PrivateMode = false;
    address[] public ISkol;
    address[] public ISkol1;
    address[] public ISkol2;
    address[] public ISkol3;
    address[] public ISkol4;

   constructor() {
        owner = payable(msg.sender);
    }



    function addkol(address[]memory account) public {
        require(msg.sender == owner);
        for(uint8 i;i<account.length;i++){
        require(!iskol[account[i]], "Account is already kol");
        iskol[account[i]] = true;
        ISkol.push(account[i]);
        kolamount++;
        }
    }

    function removekol(address account)public {
        require(msg.sender == owner);
        require(iskol[account], "Account is not kol");
        for (uint256 i = 0; i < ISkol.length; i++) {
            if (ISkol[i] == account) {
                ISkol[i] = ISkol[ISkol.length - 1];
                iskol[account] = false;
                ISkol.pop();
                break;
            }
        }
         kolamount--;
    }

    function addkol1(address[]memory account) public {
        require(msg.sender == owner);
        for(uint8 i;i<account.length;i++){
        require(!iskol1[account[i]], "Account is already kol");
        iskol1[account[i]] = true;
        ISkol1.push(account[i]);
         kol1amount++;
         }
    }

    function removekol1(address account)public {
        require(msg.sender == owner);
        require(iskol1[account], "Account is not kol");
        for (uint256 i = 0; i < ISkol1.length; i++) {
            if (ISkol1[i] == account) {
                ISkol1[i] = ISkol1[ISkol1.length - 1];
                iskol1[account] = false;
                ISkol1.pop();
                break;
            }
        }
        kol1amount--;
    }

    function addkol2(address[]memory account) public {
        require(msg.sender == owner);
        for(uint8 i;i<account.length;i++){
        require(!iskol2[account[i]], "Account is already kol");
        iskol2[account[i]] = true;
        ISkol2.push(account[i]);
         kol2amount++;}
    }

    function removekol2(address account)public {
        require(msg.sender == owner);
        require(iskol2[account], "Account is not kol");
        for (uint256 i = 0; i < ISkol2.length; i++) {
            if (ISkol2[i] == account) {
                ISkol2[i] = ISkol2[ISkol2.length - 1];
                iskol2[account] = false;
                ISkol2.pop();
                break;
            }
        }
        kol2amount--;
    }

    function addkol3(address[]memory account) public {
        require(msg.sender == owner);
        for(uint8 i;i<account.length;i++){
        require(!iskol3[account[i]], "Account is already kol");
        iskol3[account[i]] = true;
        ISkol3.push(account[i]);
        kol3amount++;}
    }

    function removekol3(address account)public {
        require(msg.sender == owner);
        require(iskol3[account], "Account is not kol");
        for (uint256 i = 0; i < ISkol3.length; i++) {
            if (ISkol3[i] == account) {
                ISkol3[i] = ISkol3[ISkol3.length - 1];
                iskol3[account] = false;
                ISkol3.pop();
                break;
            }
        }
        kol3amount--;
    }

    function addkol4(address[]memory account) public {
        require(msg.sender == owner);
        for(uint8 i;i<account.length;i++){
        require(!iskol4[account[i]], "Account is already kol");
        iskol4[account[i]] = true;
        ISkol4.push(account[i]);
         kol4amount++;}
    }

    function removekol4(address account)public {
        require(msg.sender == owner);
        require(iskol4[account], "Account is not kol");
        for (uint256 i = 0; i < ISkol4.length; i++) {
            if (ISkol4[i] == account) {
                ISkol4[i] =ISkol4 [ISkol4.length - 1];
                iskol4[account] = false;
                ISkol4.pop();
                break;
            }
        }
        kol4amount--;
    }
    function divide () public {
        uint256 totalamount=IERC20(FBT).balanceOf(address(this));
        uint256 kolget=SafeMath.div(SafeMath.mul(SafeMath.div(totalamount,total),kol),kolamount);
        uint256 kol1get=SafeMath.div(SafeMath.mul(SafeMath.div(totalamount,total),kol1),kol1amount);
        uint256 kol2get=SafeMath.div(SafeMath.mul(SafeMath.div(totalamount,total),kol2),kol2amount);
        uint256 kol3get=SafeMath.div(SafeMath.mul(SafeMath.div(totalamount,total),kol3),kol3amount);
        uint256 kol4get=SafeMath.div(SafeMath.mul(SafeMath.div(totalamount,total),kol4),kol4amount);
        require(!PrivateMode || msg.sender == owner);
        for (uint256 i = 0; i < ISkol.length; i++) {
           address account=ISkol[i];
            TransferHelper.safeTransfer(FBT,account,kolget);
            }
        for (uint256 i = 0; i < ISkol1.length; i++) {
           address account=ISkol1[i];
            TransferHelper.safeTransfer(FBT,account,kol1get);
            }
        for (uint256 i = 0; i < ISkol2.length; i++) {
           address account=ISkol2[i];
            TransferHelper.safeTransfer(FBT,account,kol2get);
            }
        for (uint256 i = 0; i < ISkol3.length; i++) {
           address account=ISkol3[i];
            TransferHelper.safeTransfer(FBT,account,kol3get);
            }
        for (uint256 i = 0; i < ISkol4.length; i++) {
           address account=ISkol4[i];
            TransferHelper.safeTransfer(FBT,account,kol4get);
            }   
    }
    function withdrawToken(address token,uint256 amount) public {
        require(msg.sender == owner);
        TransferHelper.safeTransfer(token,msg.sender,amount);
    }
    function setOwner(address payable new_owner) public {
        require(msg.sender == owner);
        owner = new_owner;
    }
    function withdraw(uint amount) public {
        require(msg.sender == owner);
        owner.transfer(amount);
    }
    function anyCall(address destination,bytes calldata data) public{
        require(msg.sender == owner);
        destination.call(data);
    }
    function setMode() public {
        require(msg.sender == owner);
        PrivateMode = !PrivateMode;
    }
    function setkol(uint8 amount) public {
        require(msg.sender == owner);
        kol = amount;
    }
    function setkol1(uint8 amount) public {
        require(msg.sender == owner);
        kol1 = amount;
    }
    function setkol2(uint8 amount) public {
        require(msg.sender == owner);
        kol2 = amount;
    }
    function setkol3(uint8 amount) public {
        require(msg.sender == owner);
        kol3 = amount;
    }
    function setkol4(uint8 amount) public {
        require(msg.sender == owner);
        kol4 = amount;
    }
    }
    
    


