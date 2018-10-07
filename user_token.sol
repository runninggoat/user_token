pragma solidity ^0.4.24;

contract UserToken {

    address owner;

    constructor() public {
        owner = msg.sender;
    }

    struct Token {
        address user;
        string token;
        string secretHash;
    }

    mapping(address => Token) private tokens;

    event TokenUpdate(address indexed _user, string indexed msg);

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    function updateToken(address _user, string _token, string _secretHash) public onlyOwner {
        Token memory token = Token(_user, _token, _secretHash);
        tokens[_user] = token;
        emit TokenUpdate(_user, "Token updated");
    }

    function getToken(string _secretHash) public view returns (string) {
        require(
            keccak256(abi.encodePacked(tokens[msg.sender].secretHash))
                == keccak256(abi.encodePacked(_secretHash)),
            "Invalid secret"
        );
        return tokens[msg.sender].token;
    }
}