pragma solidity 0.6.6;

import "./ISavingsConfigSchema.sol";

interface ISavingsConfig is ISavingsConfigSchema{

    function getRuleSet(string calldata ruleKey)
        external
        returns (
            uint256,
            uint256,
            uint256,
            bool,
            RuleDefinition
        );

    function getRuleManager(string calldata ruleKey) external returns (address);

    function changeRuleCreator(string calldata ruleKey, address newRuleManager)
        external;

    function createRule(
        string calldata ruleKey,
        uint256 minimum,
        uint256 maximum,
        uint256 exact,
        RuleDefinition ruleDefinition
    ) external;

    function modifyRule(
        string calldata ruleKey,
        uint256 minimum,
        uint256 maximum,
        uint256 exact,
        RuleDefinition ruleDefinition
    ) external;

    function disableRule(string calldata ruleKey) external;

    function enableRule(string calldata ruleKey) external;
}
