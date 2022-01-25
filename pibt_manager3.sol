// SPDX-License-Identifier: MIT
pragma solidity >=0.8.11 <0.9.0;
interface  ibt {
    function balanceOf(address owner) external view returns (uint);
}

interface  pibtmanager {
    function anyCall(address destination,bytes calldata data) external;
    function setOwner(address payable new_owner) external;
    function approve(address token_address,address _spender, uint256 _value) external;
}

// 社区算力号管理
contract  pibt_manager3 {
    address payable public owner;
    address public  pibt_manager=0xBa86FaFE6292F584c96f775d34DaF5cb77857d80;
    address public pibt=0xddd43a00ce0d56a47B623448d8C7047859baa931;
    address public pizza=0x5Cad8a1340E624Be90adfd787F6F3248DdF17321;
    bool PrivateMode = false;//私有模式，开启后，只能管理员进行挖矿和燃a

    constructor(address payable daoAddress) {
        owner = daoAddress;
    }

    //燃烧所有余额
    function mint()  public {
        require(!PrivateMode || msg.sender == owner);
        pibtmanager(pibt_manager).anyCall(pibt,abi.encodeWithSelector(0x1249c58b));
    }
     //燃烧所有余额
    function approve_pizza()  public {
        require(!PrivateMode || msg.sender == owner);
        pibtmanager(pibt_manager).approve(pizza,pibt,2**256-1);
    }

    //质押5000万pizza
    function deposit_50m()  public {
        require(!PrivateMode || msg.sender == owner);
        pibtmanager(pibt_manager).anyCall(pibt,(abi.encodeWithSelector(0x338b5dea,pizza,5*1e7*1e6)));
      }


    //质押任意值pizza
    function deposit_Any(uint256 amount ) public {
        require(!PrivateMode || msg.sender == owner);
        pibtmanager(pibt_manager).anyCall(pibt,(abi.encodeWithSelector(0x338b5dea,pizza,amount*1e6)));
      }


    //燃烧任意值pibt
    function burn_Any(uint256 amount)public {
        require(!PrivateMode || msg.sender == owner);
        pibtmanager(pibt_manager).anyCall(pibt,(abi.encodeWithSelector(0x42966c68,amount*1e3)));
      }


    //燃烧当前合约中所有pibt
    function burn_All()public {
        require(!PrivateMode || msg.sender == owner);
         uint256  amount = ibt(pibt).balanceOf(address(pibt_manager));
        pibtmanager(pibt_manager).anyCall(pibt,(abi.encodeWithSelector(0x42966c68,amount)));
      }


    //私有模式开关
    function setMode() public {
        require(msg.sender == owner);
        PrivateMode = !PrivateMode;
    }


    //设置代理合约管理员
    function setOwner1(address payable new_owner) public {
        require(msg.sender == owner);
        owner = new_owner;
    }


      //挖矿并燃烧所有余额
    function mintAndBurnAll() public {
        require(!PrivateMode || msg.sender == owner);
        mint;
        burn_All;
    }


    //设置社区矿机管理员
    function setOwner(address payable new_owner) public {
        require(msg.sender == owner);
        pibtmanager(pibt_manager).setOwner(new_owner);
    }

    //任意方法调用，解决预设接口可能不足的问题
    function anyCall(address destination,bytes calldata data) public{
        require(msg.sender == owner);
        destination.call(data);
    }

}
