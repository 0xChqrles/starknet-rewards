use starknet::testing;

use openzeppelin::utils::serde::SerializedAppend;

use openzeppelin::tests::mocks::erc20_mocks::SnakeERC20Mock;
use openzeppelin::token::erc20::dual20::DualCaseERC20Trait;

use openzeppelin::account::AccountABIDispatcher;
use openzeppelin::tests::mocks::account_mocks::SnakeAccountMock;

// locals
use super::constants;

mod partial_eq;
mod zeroable;

fn deploy(contract_class_hash: felt252, calldata: Array<felt252>) -> starknet::ContractAddress {
  let (address, _) = starknet::deploy_syscall(contract_class_hash.try_into().unwrap(), 0, calldata.span(), false)
    .unwrap();

  address
}

fn setup_ether(
  recipient: starknet::ContractAddress,
  expected_address: starknet::ContractAddress
) -> starknet::ContractAddress {
  let mut calldata = array![];

  calldata.append_serde('Ether');
  calldata.append_serde('ETH');
  calldata.append_serde(1_000_000_000_000_000_000_u256); // 1 ETH
  calldata.append_serde(recipient);

  // deploy
  let ether_contract_address = deploy(SnakeERC20Mock::TEST_CLASS_HASH, calldata);

  // make sure the contract has been deployed with the right address
  assert(ether_contract_address == expected_address, 'Bad deployment order');

  // allow reward funds to spend owner's ETH
  testing::set_contract_address(recipient);

  let ether = constants::ETHER(ether_contract_address);

  let recipient_balance = ether.balance_of(recipient);
  ether.approve(spender: constants::FUNDS(), amount: recipient_balance);

  ether_contract_address
}

fn setup_signer(public_key: felt252, expected_address: starknet::ContractAddress) -> AccountABIDispatcher {
  let calldata = array![public_key];

  let signer_address = deploy(SnakeAccountMock::TEST_CLASS_HASH, calldata);

  // make sure the contract has been deployed with the right address
  assert(signer_address == expected_address, 'Bad deployment order');

  AccountABIDispatcher { contract_address: signer_address }
}
