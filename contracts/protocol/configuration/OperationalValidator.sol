// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.7;

import {IPoolAddressesProvider} from '../../interfaces/IPoolAddressesProvider.sol';
import {IOperationalValidator} from '../../interfaces/IOperationalValidator.sol';
import {ISequencerOracle} from '../../interfaces/ISequencerOracle.sol';

/**
 * @title OperationalValidator
 * @author Aave
 * @notice
 */
contract OperationalValidator is IOperationalValidator {
  IPoolAddressesProvider public _addressesProvider;
  ISequencerOracle public _sequencerOracle;
  uint256 public _gracePeriod;

  /**
   * @notice Constructor
   * @dev
   * @param provider The address of the PoolAddressesProvider
   */
  constructor(
    IPoolAddressesProvider provider,
    ISequencerOracle sequencerOracle,
    uint256 gracePeriod
  ) {
    _addressesProvider = provider;
    _sequencerOracle = sequencerOracle;
    _gracePeriod = gracePeriod;
  }

  /// @inheritdoc IOperationalValidator
  function isBorrowAllowed() public view override returns (bool) {
    // If the sequencer goes down, borrowing is not allowed
    return _isUpAndGracePeriodPassed();
  }

  /// @inheritdoc IOperationalValidator
  function isLiquidationAllowed(uint256 healthFactor) public view override returns (bool) {
    if (healthFactor < 0.95 ether) {
      return true;
    }
    return _isUpAndGracePeriodPassed();
    // If the sequencer goes down AND HF > 0.9, liquidation is not allowed
    // If timestampSequencerGotUp - block.timestamp > gracePeriod, liquidation allowed
  }

  function _isUpAndGracePeriodPassed() internal view returns (bool) {
    (bool isDown, uint256 timestampGotUp) = _sequencerOracle.latestAnswer();
    return !isDown && block.timestamp - timestampGotUp > _gracePeriod;
  }
}
