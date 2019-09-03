pragma solidity 0.5.8;

import "@ensdomains/ens/contracts/ENS.sol";
import "@ensdomains/resolver/contracts/Resolver.sol";
import "./Clock.sol";

// This registrar allows a set of claimant addresses to alias any subnode to an address.
contract EthvaultENSRegistrar is Clock {
  // The public resolver address can be found as the resolver of the "resolver" top level node
  bytes32 public constant RESOLVER_NODE = keccak256(abi.encodePacked(keccak256(abi.encodePacked(bytes32(0), keccak256("eth"))), keccak256("resolver")));

  // Emitted when a user is registered
  event Registration(address claimant, bytes32 rootNode, bytes32 label, address owner, uint256 value);

  ENS public ens;

  // The addresses that may claim ENS subdomains for the given node
  mapping(address => bool) public isClaimant;

  constructor(ENS _ens) public {
    ens = _ens;

    isClaimant[msg.sender] = true;
  }

  // Only one of the claimants may call a function.
  modifier claimantOnly() {
    if (!isClaimant[msg.sender]) {
      revert("unauthorized - must be from claimant");
    }

    _;
  }

  // Add claimants to the set.
  function addClaimants(address[] calldata claimants) external claimantOnly {
    for (uint i = 0; i < claimants.length; i++) {
      isClaimant[claimants[i]] = true;
    }
  }

  // Remove claimants from the set.
  function removeClaimants(address[] calldata claimants) external claimantOnly {
    for (uint i = 0; i < claimants.length; i++) {
      if (claimants[i] == msg.sender) {
        revert("cannot remove self");
      }
      isClaimant[claimants[i]] = false;
    }
  }

  // Compute the namehash from the label and the root node.
  function namehash(bytes32 rootNode, bytes32 label) view public returns (bytes32) {
    return keccak256(abi.encodePacked(rootNode, label));
  }

  // Get the data that the user should sign to release a name.
  function getReleaseSignData(bytes32 rootNode, bytes32 label, uint256 expirationTimestamp) pure public returns (bytes32) {
    return keccak256(abi.encodePacked(rootNode, label, expirationTimestamp));
  }

  /**
   * @dev Recover signer address from a message by using their signature
   * @param _hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
   * @param _sig bytes signature, the signature is generated using web3.eth.sign()
   */
  function recover(bytes32 _hash, bytes memory _sig)
    internal
    pure
    returns (address)
  {
    bytes32 r;
    bytes32 s;
    uint8 v;

    // Check the signature length
    if (_sig.length != 65) {
      return (address(0));
    }

    // Divide the signature in r, s and v variables
    // ecrecover takes the signature parameters, and the only way to get them
    // currently is to use assembly.
    // solium-disable-next-line security/no-inline-assembly
    assembly {
      r := mload(add(_sig, 32))
      s := mload(add(_sig, 64))
      v := byte(0, mload(add(_sig, 96)))
    }

    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
    if (v < 27) {
      v += 27;
    }

    // If the version is correct return the signer address
    if (v != 27 && v != 28) {
      return (address(0));
    } else {
      // solium-disable-next-line arg-overflow
      return ecrecover(_hash, v, r, s);
    }
  }

  /**
   * toEthSignedMessageHash
   * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
   * and hash the result
   */
  function toEthSignedMessageHash(bytes32 _hash)
    internal
    pure
    returns (bytes32)
  {
    // 32 is the length in bytes of hash,
    // enforced by the type signature above
    return keccak256(
      abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
    );
  }

  /**
   * Allow a subnode to be released given the user's signature. Anyone can perform this operation as long as the
   * signature is valid and has not expired.
   * @param label The label to release
   * @param expirationTimestamp The timestamp for when the signature to release the label expires
   * @param signature The signature of the label and expiration timestamp
   */
  function release(bytes32 rootNode, bytes32 label, uint256 expirationTimestamp, bytes calldata signature) external {
    bytes32 subnode = namehash(rootNode, label);

    address currentOwner = ens.owner(subnode);

    if (currentOwner == address(0)) {
      // No-op, just return.
      return;
    }

    address signer = recover(
      toEthSignedMessageHash(getReleaseSignData(rootNode, label, expirationTimestamp)),
      signature
    );

    if (signer == address(0)) {
      revert("invalid signature");
    }

    if (signer != currentOwner) {
      revert("signature is not valid");
    }

    if (expirationTimestamp < getTime()) {
      revert("signature has expired");
    }

    ens.setSubnodeOwner(rootNode, label, address(0));
  }

  // Return the public resolver. This is called to get the public resolver to use during registration.
  function getPublicResolver() view public returns (Resolver) {
    address resolverAddr = ens.resolver(RESOLVER_NODE);

    if (resolverAddr == address(0)) {
      revert("failed to get resolver address");
    }

    Resolver resolver = Resolver(resolverAddr);

    address publicResolver = resolver.addr(RESOLVER_NODE);
    if (publicResolver == address(0)) {
      revert("resolver had address zero for resolver node");
    }

    return Resolver(publicResolver);
  }

  /**
   * Register a subdomain name, sets the resolver, updates the resolver, and sets the address of the resolver to the
   * new owner. Also transfers any additional value to each address.
   * @param rootNode The domain node for which the label should be registered as a subnode
   * @param labels The hashes of the label to register
   * @param owners The addresses of the new owners
   * @param values The WEI values to send to each address
   */
  function register(bytes32 rootNode, bytes32[] calldata labels, address payable[] calldata owners, uint256[] calldata values) external payable claimantOnly {
    if (labels.length != owners.length || owners.length != values.length) {
      revert("must pass the same number of labels and owners");
    }

    uint256 dispersedTotal = 0;

    for (uint i = 0; i < owners.length; i++) {
      address payable owner = owners[i];
      if (owner == address(0)) {
        continue;
      }

      // Compute the subnode hash
      bytes32 subnode = namehash(rootNode, labels[i]);

      // Get the current owner of this subnode
      address currentOwner = ens.owner(subnode);

      // Prevent overwriting ownership with a different address
      if (currentOwner != address(0) && currentOwner != owner) {
        revert("the label owner may not be changed");
      }

      // Skip if the current owner is already the owner
      if (currentOwner == owner) {
        continue;
      }

      Resolver publicResolver = getPublicResolver();

      // First set it to this, so we can update it.
      ens.setSubnodeOwner(rootNode, labels[i], address(this));

      // Set the resolver for the subnode to the public resolver
      ens.setResolver(subnode, address(publicResolver));

      // Set the address to the owner in the public resolver
      publicResolver.setAddr(subnode, owner);

      // Finally pass ownership to the new owner.
      ens.setSubnodeOwner(rootNode, labels[i], owner);

      if (values[i] > 0) {
        dispersedTotal = dispersedTotal + values[i];
        owner.transfer(values[i]);
      }

      emit Registration(msg.sender, rootNode, labels[i], owner, values[i]);
    }

    if (dispersedTotal < msg.value) {
      msg.sender.transfer(msg.value - dispersedTotal);
    }
  }

}