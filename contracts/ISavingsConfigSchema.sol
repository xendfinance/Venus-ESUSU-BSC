// SPDX-License-Identifier: MIT
pragma solidity 0.6.6;

interface ISavingsConfigSchema {
    struct RuleSet {
        bool exists;
        uint256 minimum;
        uint256 maximum;
        uint256 exact;
        bool applies;
        RuleDefinition ruleDefinition;
    }

    enum RuleDefinition {RANGE, VALUE}
}
