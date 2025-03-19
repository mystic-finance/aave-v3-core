// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;


/// @title EventsLib
/// @author Mystic Labs
/// @custom:contact security@morpho.org
/// @notice Library exposing events.
library EventsLib {

  /// @notice Emitted when a new vault is created.
  /// @param vault The address of the vault.
  /// @param caller The caller of the function.
  /// @param initialOwner The initial owner of the vault.
  /// @param initialTimelock The initial timelock of the vault.
  /// @param asset The address of the underlying asset.
  /// @param name The name of the vault.
  /// @param symbol The symbol of the vault.
  /// @param salt The salt used for the vault's CREATE2 address.
  event CreateVault(
    address indexed vault,
    address indexed caller,
    address initialOwner,
    uint256 initialTimelock,
    address indexed asset,
    string name,
    string symbol,
    bytes32 salt
  );
}
