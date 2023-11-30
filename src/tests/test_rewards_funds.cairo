use debug::PrintTrait;
use zeroable::Zeroable;
use starknet::testing;

use openzeppelin::introspection::src5::SRC5Component::SRC5Impl;

use openzeppelin::token::erc20::dual20::DualCaseERC20Trait;

// locals
use rewards::rewards::funds::RewardsFundsComponent::InternalTrait as RewardsFundsInternalTrait;
use rewards::rewards::data::RewardsDataComponent::InternalTrait as RewardsDataInternalTrait;

use super::mocks::rewards_funds_mock::RewardsFundsMock;

use super::utils;
use super::utils::partial_eq::{ RewardModelEq, RewardContentEq };
use super::utils::zeroable::{ RewardModelZeroable, RewardContentZeroable };

use super::constants;

fn STATE() -> RewardsFundsMock::ContractState {
  RewardsFundsMock::contract_state_for_testing()
}

fn setup() -> RewardsFundsMock::ContractState {
  let mut state = STATE();

  // setup ether - 0x2
  let ether_contract_address = utils::setup_ether(
    recipient: constants::OWNER(),
    expected_address: constants::ETHER_1().contract_address
  );

  // set funds as the contract address
  testing::set_contract_address(constants::FUNDS());

  state.rewards_data._add_reward_model(constants::VALID::REWARD_MODEL_1());
  state.rewards_funds.initializer(ether_contract_address_: ether_contract_address);

  state
}

//
// Tests
//

// collect reward price

#[test]
#[available_gas(20000000)]
fn test__collect_reward_price() {
  let mut state = setup();
  let ether = constants::ETHER_1();
  let reward_model = constants::VALID::REWARD_MODEL_CHEAP();

  let owner_balance_before = ether.balance_of(constants::OWNER());
  let funds_balance_before = ether.balance_of(constants::FUNDS());

  // add cheap reward model
  let reward_model_id = state.rewards_data._add_reward_model(:reward_model);

  // collect cheap reward price
  state.rewards_funds._collect_reward_price(from: constants::OWNER(), :reward_model_id);

  assert(
    constants::ETHER_1().balance_of(constants::OWNER()) == owner_balance_before - reward_model.price,
    'Invalid owner balance after'
  );
  assert(
    constants::ETHER_1().balance_of(constants::FUNDS()) == funds_balance_before + reward_model.price,
    'Invalid funds balance after'
  );
}

#[test]
#[available_gas(20000000)]
fn test__collect_reward_price_free_price() {
  let mut state = setup();
  let ether = constants::ETHER_1();
  let reward_model = constants::VALID::REWARD_MODEL_FREE();

  let owner_balance_before = ether.balance_of(constants::OWNER());
  let funds_balance_before = ether.balance_of(constants::FUNDS());

  // add cheap reward model
  let reward_model_id = state.rewards_data._add_reward_model(:reward_model);

  // collect free reward price
  state.rewards_funds._collect_reward_price(from: constants::OWNER(), :reward_model_id);

  assert(constants::ETHER_1().balance_of(constants::OWNER()) == owner_balance_before, 'Invalid owner balance after');
  assert(constants::ETHER_1().balance_of(constants::FUNDS()) == funds_balance_before, 'Invalid funds balance after');
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('funds.invalid_rewards_model',))]
fn test__collect_reward_price_invalid_reward_model_id() {
  let mut state = setup();
  let ether = constants::ETHER_1();

  let owner_balance_before = ether.balance_of(constants::OWNER());
  let funds_balance_before = ether.balance_of(constants::FUNDS());

  // collect cheap reward price
  state.rewards_funds._collect_reward_price(
    from: constants::OWNER(),
    reward_model_id: constants::VALID::REWARD_MODEL_2_ID()
  );
}

// withdraw

#[test]
#[available_gas(20000000)]
fn test__withdraw() {
  let mut state = setup();
  let ether = constants::ETHER_1();
  let amount = 1_000;

  // send a few ETH to the funds
  testing::set_contract_address(constants::OWNER());
  ether.transfer(recipient: constants::FUNDS(), :amount);
  testing::set_contract_address(constants::FUNDS());

  // withdraw
  state.rewards_funds._withdraw(recipient: constants::DISPATCHER_1());

  assert(constants::ETHER_1().balance_of(constants::DISPATCHER_1()) == amount, 'Bad dispatcher balance after');
  assert(constants::ETHER_1().balance_of(constants::FUNDS()).is_zero(), 'Bad funds balance after');
}

#[test]
#[available_gas(20000000)]
fn test__withdraw_zero() {
  let mut state = setup();
  let ether = constants::ETHER_1();

  // withdraw
  state.rewards_funds._withdraw(recipient: constants::DISPATCHER_1());

  assert(constants::ETHER_1().balance_of(constants::DISPATCHER_1()).is_zero(), 'Bad dispatcher balance after');
  assert(constants::ETHER_1().balance_of(constants::FUNDS()).is_zero(), 'Bad funds balance after');
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('funds.withdraw_to_zero',))]
fn test__withdraw_to_zero() {
  let mut state = setup();
  let ether = constants::ETHER_1();

  // withdraw
  state.rewards_funds._withdraw(recipient: constants::ZERO());
}
