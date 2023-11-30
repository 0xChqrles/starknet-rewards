use messages::typed_data::typed_data::TypedDataTrait;
use rewards::rewards::interface::IRewardsMessages;
use debug::PrintTrait;
use starknet::testing;

use openzeppelin::account::AccountABIDispatcher;
use openzeppelin::tests::mocks::account_mocks::SnakeAccountMock;

// locals
use rewards::rewards::messages::RewardsMessagesComponent::InternalTrait as RewardsMessagesInternalTrait;

use super::mocks::rewards_messages_mock::RewardsMessagesMock;

use super::constants;
use super::utils;

use rewards::typed_data::rewards::RewardMessage;

fn STATE() -> RewardsMessagesMock::ContractState {
  RewardsMessagesMock::contract_state_for_testing()
}

fn setup() -> RewardsMessagesMock::ContractState {
  // setup chain id to compute vouchers hashes
  testing::set_chain_id(constants::CHAIN_ID);

  // setup voucher signer - 0x1
  let voucher_signer = setup_signer(constants::PUBLIC_KEY);
  assert(voucher_signer.contract_address == constants::SIGNER(), 'Bad deployment order');

  STATE()
}

fn setup_signer(public_key: felt252) -> AccountABIDispatcher {
  let calldata = array![public_key];

  let signer_address = utils::deploy(SnakeAccountMock::TEST_CLASS_HASH, calldata);
  AccountABIDispatcher { contract_address: signer_address }
}

//
// Tests
//

#[test]
#[available_gas(20000000)]
fn test_consume_valid_reward_from() {
  let mut state = setup();

  let signer = constants::SIGNER();
  let reward = constants::VALID::REWARD_1();
  let signature = constants::VALID::REWARD_1_SIGNATURE();

  state.consume_valid_reward_from(from: signer, :reward, :signature);
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('messages.invalid_reward_sig',))]
fn test_consume_valid_reward_from_invalid_signature() {
  let mut state = setup();

  let signer = constants::SIGNER();
  let mut reward = constants::VALID::REWARD_1();
  let signature = constants::VALID::REWARD_1_SIGNATURE();

  reward.reward_model_id += 1;

  state.consume_valid_reward_from(from: signer, :reward, :signature);
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('messages.reward_consumed',))]
fn test_consume_valid_reward_from_already_consumed() {
  let mut state = setup();

  let signer = constants::SIGNER();
  let reward = constants::VALID::REWARD_1();
  let signature = constants::VALID::REWARD_1_SIGNATURE();

  // consume reward twice >_<
  state.consume_valid_reward_from(from: signer, :reward, :signature);
  state.consume_valid_reward_from(from: signer, :reward, :signature);
}
