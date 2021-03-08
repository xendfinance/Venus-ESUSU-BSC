// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "./Ownable.sol";
import "./ISavingsConfigSchema.sol";

contract SavingsConfig is ISavingsConfigSchema, Ownable {

    mapping(string => RuleSet) public RuleMapping;
    mapping(string => address) public RuleModifier;

    constructor() public {}

    function getRuleSet(string calldata ruleKey)
        external
        returns (
            uint256,
            uint256,
            uint256,
            bool,
            RuleDefinition
        )
    {
        RuleSet memory ruleSet = RuleMapping[ruleKey];

        require(
            ruleSet.exists == true,
            "No rule definitions found for rule key"
        );

        return (
            ruleSet.minimum,
            ruleSet.maximum,
            ruleSet.exact,
            ruleSet.applies,
            ruleSet.ruleDefinition
        );
    }

    function getRuleManager(string calldata ruleKey)
        external
        returns (address)
    {
        RuleSet memory ruleSet = RuleMapping[ruleKey];
        require(
            ruleSet.exists == true,
            "No rule definitions found for rule key"
        );
        address ruleManager = RuleModifier[ruleKey];
        return (ruleManager);
    }

    function changeRuleCreator(string calldata ruleKey, address newRuleManager)
        external
        onlyRuleCreatorOrOwner(ruleKey)
    {
        require(
            newRuleManager != address(0),
            "Invalid address passed for new rule manager"
        );
        RuleModifier[ruleKey] = newRuleManager;
    }

    function createRule(
        string calldata ruleKey,
        uint256 minimum,
        uint256 maximum,
        uint256 exact,
        RuleDefinition ruleDefinition
    ) external {
        RuleSet memory rule = RuleSet(
            true,
            minimum,
            maximum,
            exact,
            true,
            ruleDefinition
        );
        _validateRuleCreation(ruleKey, rule);
        RuleMapping[ruleKey] = rule;
        RuleModifier[ruleKey] = msg.sender;
    }

    function modifyRule(
        string calldata ruleKey,
        uint256 minimum,
        uint256 maximum,
        uint256 exact,
        RuleDefinition ruleDefinition
    ) external onlyRuleCreatorOrOwner(ruleKey) {
        RuleSet memory ruleSet = _getRule(ruleKey);
        ruleSet.minimum = minimum;
        ruleSet.maximum = maximum;
        ruleSet.exact = exact;
        ruleSet.ruleDefinition = ruleDefinition;
        _validateRuleCreation(ruleKey, ruleSet);
    }

    function disableRule(string calldata ruleKey)
        external
        onlyRuleCreatorOrOwner(ruleKey)
    {
        RuleSet memory ruleSet = _getRule(ruleKey);
        require(ruleSet.applies == true, "Rule set is already disabled");
        ruleSet.applies = false;
        _saveRule(ruleKey, ruleSet);
    }

    function enableRule(string calldata ruleKey)
        external
        onlyRuleCreatorOrOwner(ruleKey)
    {
        RuleSet memory ruleSet = _getRule(ruleKey);
        require(ruleSet.applies == false, "Rule set is already enabled");
        ruleSet.applies = true;
        _saveRule(ruleKey, ruleSet);
    }

    function _getRule(string memory ruleKey) internal returns (RuleSet memory) {
        bool ruleExist = RuleMapping[ruleKey].exists;
        require(ruleExist == true, "Rule does not exist");
        RuleSet memory ruleSet = RuleMapping[ruleKey];
        return ruleSet;
    }

    function _saveRule(string memory ruleKey, RuleSet memory ruleSet) internal {
        RuleMapping[ruleKey] = ruleSet;
    }

    function _validateRuleCreation(string memory ruleKey, RuleSet memory rule)
        internal
    {
        bool ruleExist = RuleMapping[ruleKey].exists;
        require(ruleExist == false, "Rule configuration has already been set");

        if (rule.ruleDefinition == RuleDefinition.RANGE) {
            require(
                rule.exact == 0,
                "Rule definition for range requires that exact field is 0"
            );
        } else if (rule.ruleDefinition == RuleDefinition.VALUE) {
            require(
                rule.minimum == 0 && rule.maximum == 0,
                "Rule definition for value requires that minimum and maximum field is 0"
            );
        }
    }

    modifier onlyRuleCreatorOrOwner(string memory ruleKey) {
        RuleSet memory ruleSet = _getRule(ruleKey);
        address ruleCreator = RuleModifier[ruleKey];

        require(
            msg.sender == ruleCreator || msg.sender == owner,
            "cannot modify rule, permission denied"
        );
        _;
    }
}
