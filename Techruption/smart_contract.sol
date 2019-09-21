pragma solidity ^0.5.0;
 
import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';
 
import {IDatabase} from "./governor.sol";
import "./common/governor-nobody.sol";
import "./common/governor-owner.sol";
 
contract Database is IDatabase {
    address public governorUpdate;
    address public governorExecute;
    Storage databaseStorage;
 
    event NewGovernors(
        address governorUpdate,
        address governorExecute
    );
 
    constructor(address _databaseStorage) public {
        governorUpdate = address(new Governor_Owner(address(this)));
        governorExecute = address(new Governor_Nobody(address(this)));
        databaseStorage = Storage(_databaseStorage);
        emit NewGovernors(governorUpdate, governorExecute);
    }
 
    function set(address a, uint v) external
             Governed(governorExecute) NeedsValidStorage() {
        databaseStorage.set(a, v);
    }
 
    function get(address a) external view
             Governed(governorExecute) NeedsValidStorage() returns(uint) {
        return databaseStorage.get(a);
    }
 
    function updateGovernorUpdate(address _governor) external
             Governed(governorUpdate) {
        governorUpdate = _governor;
    }
 
    function updateGovernorExecute(address _governor) external
             Governed(governorUpdate) {
        governorExecute = _governor;
    }
 
    // The storage can be transferred to a new Database contract, in case this one is
    // deemed unfit. The new owner should be passed.
    function transferStorage(address newOwner) external
             Governed(governorUpdate) {
        databaseStorage.transferOwnership(newOwner);
        databaseStorage = Storage(0x0);
    }
 
    modifier Governed(address governor) {
        require(msg.sender == governor, "Only the appropriate governor may call this function");
        _;
    }
 
    modifier NeedsValidStorage() {
        require(address(databaseStorage) != address(0), "Storage contract was renounced");
        _;
    }
}
 
contract Storage is Ownable {
    mapping (address => uint) valuation;
 
    function set(address a, uint v) external onlyOwner() {
        valuation[a] = v;
    }
 
    function get(address a) external view onlyOwner() returns(uint) {
        return valuation[a];
    }
}
 
// governor.sol
 
pragma solidity ^0.5.0;
 
interface IDatabase {
    function updateGovernorUpdate(address _governor) external;
    function updateGovernorExecute(address _governor) external;
    function transferStorage(address newOwner) external;
    function set(address, uint) external;
    function get(address) external view returns(uint);
}
 
// The "empty governor". No access controls are in place, but the constructor
// is internal (i.e. it is an 'abstract class' and can not be instantiated).
// Other governors can extend this one to provide authentication functionality.
contract Governor {
    IDatabase database;
 
    constructor(address _database) internal {
        database = IDatabase(_database);
    }
 
    function updateGovernorUpdate(address _newGovernor) permissioned() public {
        database.updateGovernorUpdate(_newGovernor);
    }
 
    function updateGovernorExecute(address _newGovernor) permissioned() public {
        database.updateGovernorExecute(_newGovernor);
    }
 
    function transferStorage(address newOwner) permissioned() public {
        database.transferStorage(newOwner);
    }
 
    function set(address a, uint v) permissioned() public {
        database.set(a, v);
    }
 
    function get(address a) permissioned() public view returns(uint) {
        return database.get(a);
    }
   
    modifier permissioned() {
        _;
    }
}
 
// common/governor-nobody.sol
 
pragma solidity ^0.5.0;
 
import {Governor} from "../governor.sol";
 
// This governor does not allow anything. Setting it as the update governor
// will prevent future updates!
contract Governor_Nobody is Governor {
    constructor(address _proxy) Governor(_proxy) public {}
 
    modifier permissioned() {
        revert ("Governor: Nobody may do this");
        _;
    }
   
}
 
 
// common/governor-owner.sol
 
pragma solidity ^0.5.0;
 
import {Governor} from "../governor.sol";
 
contract Governor_Owner is Governor {
    address private owner;
 
    constructor(address _proxy) Governor(_proxy) public {
        owner = tx.origin;
    }
 
    modifier permissioned() {
        require (tx.origin == owner, "Governor: Only the owner may do this");
        _;
    }
}