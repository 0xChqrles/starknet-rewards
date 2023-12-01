use openzeppelin::token::erc20::dual20::DualCaseERC20Trait;
use core::zeroable::Zeroable;
use rewards::rewards::interface::IRewardsTokens;
use debug::PrintTrait;
use starknet::testing;

use openzeppelin::account::AccountABIDispatcher;
use openzeppelin::tests::mocks::account_mocks::SnakeAccountMock;

// locals
use rewards::rewards::funds::RewardsFundsComponent::InternalTrait as RewardsFundsInternalTrait;
use rewards::rewards::tokens::RewardsTokensComponent::InternalTrait as RewardsTokensInternalTrait;
use rewards::rewards::data::RewardsDataComponent::InternalTrait as RewardsDataInternalTrait;

use rewards::rewards::interface::Reward;

use super::mocks::rewards_tokens_mock::RewardsTokensMock;

use super::constants;
use super::utils;

use super::utils::partial_eq::RewardEq;
use super::utils::zeroable::RewardZeroable;

use rewards::typed_data::rewards::RewardDispatch;

fn STATE() -> RewardsTokensMock::ContractState {
  RewardsTokensMock::contract_state_for_testing()
}

fn setup() -> RewardsTokensMock::ContractState {
  let mut state = STATE();

  // setup chain id to compute hashes
  testing::set_chain_id(constants::CHAIN_ID);

  // setup signer - 0x1
  let signer = utils::setup_signer(
    public_key: constants::SIGNER_PUBLIC_KEY,
    expected_address: constants::SIGNER()
  );

  // setup ether - 0x2
  let ether_contract_address = utils::setup_ether(
    recipient: signer.contract_address,
    expected_address: constants::ETHER_2().contract_address
  );
  let ether = constants::ETHER(ether_contract_address);

  // setup signer - 0x3
  let signer_3 = utils::setup_signer(
    public_key: constants::SIGNER_3_PUBLIC_KEY,
    expected_address: constants::SIGNER_3()
  );

  // fund SIGNER 3
  testing::set_contract_address(signer.contract_address);

  let signer_balance = ether.balance_of(account: signer.contract_address);
  ether.transfer(recipient: signer_3.contract_address, amount: signer_balance / 2);

  // approve funds to spend SIGNER_3 ETH
  testing::set_contract_address(signer_3.contract_address);

  ether.approve(spender: constants::FUNDS(), amount: signer_balance);

  // set funds as the contract address
  testing::set_contract_address(constants::FUNDS());

  state.rewards_funds.initializer(ether_contract_address_: ether_contract_address);
  state.rewards_data._add_reward_model(constants::VALID::REWARD_MODEL_CHEAP());
  state.dispatch_reward(
    reward_dispatch: constants::VALID::REWARD_DISPATCH_CHEAP(),
    signature: constants::VALID::REWARD_DISPATCH_CHEAP_SIGNATURE()
  );

  state
}

//
// Tests
//

#[test]
#[available_gas(20000000)]
fn test_owner_of() {
  let state = setup();

  assert(state.owner_of(reward_id: constants::VALID::REWARD_CHEAP_ID()) == constants::DOMAIN_1, 'Invalid owner')
}

#[test]
#[available_gas(20000000)]
fn test_owner_of_empty() {
  let state = setup();

  assert(state.owner_of(reward_id: 0).is_zero(), 'Invalid owner')
}

#[test]
#[available_gas(20000000)]
fn test_reward() {
  let state = setup();

  assert(
    state.reward(reward_id: constants::VALID::REWARD_CHEAP_ID()) == constants::VALID::REWARD_CHEAP(),
    'Invalid reward'
  )
}

#[test]
#[available_gas(20000000)]
fn test_reward_empty() {
  let state = setup();

  assert(state.reward(reward_id: 0).is_zero(), 'Invalid reward')
}

// dispatch reward

#[test]
#[available_gas(20000000)]
fn test_dispatch_reward_with_signature() {
  let mut state = setup();
  let ether = constants::ETHER_2();

  let reward_model = constants::VALID::REWARD_MODEL_CHEAP();
  let reward = constants::VALID::REWARD_CHEAP_2();

  let signer_balance_before = ether.balance_of(account: constants::SIGNER_3());
  let funds_balance_before = ether.balance_of(account: constants::FUNDS());

  state.dispatch_reward(
    reward_dispatch: constants::VALID::REWARD_DISPATCH_CHEAP_2(),
    signature: constants::VALID::REWARD_DISPATCH_CHEAP_2_SIGNATURE()
  );

  assert(state.reward(reward_id: constants::VALID::REWARD_CHEAP_2_ID()) == reward, 'Invalid reward');
  assert(state.owner_of(reward_id: constants::VALID::REWARD_CHEAP_2_ID()) == constants::DOMAIN_2, 'Invalid owner');

  assert(
    ether.balance_of(constants::SIGNER()) == signer_balance_before - reward_model.price,
    'Invalid owner balance after'
  );
  assert(
    ether.balance_of(constants::FUNDS()) == funds_balance_before + reward_model.price,
    'Invalid funds balance after'
  );
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('messages.reward_consumed',))]
fn test_dispatch_reward_with_signature_twice() {
  let mut state = setup();

  state.dispatch_reward(
    reward_dispatch: constants::VALID::REWARD_DISPATCH_CHEAP_2(),
    signature: constants::VALID::REWARD_DISPATCH_CHEAP_2_SIGNATURE()
  );
  state.dispatch_reward(
    reward_dispatch: constants::VALID::REWARD_DISPATCH_CHEAP_2(),
    signature: constants::VALID::REWARD_DISPATCH_CHEAP_2_SIGNATURE()
  );
}

#[test]
#[available_gas(20000000)]
fn test_dispatch_reward_with_invalid_signature() {
  let mut state = setup();
}

#[test]
#[available_gas(20000000)]
fn test_dispatch_reward_without_signature() {
  let mut state = setup();
}

#[test]
#[available_gas(20000000)]
fn test_dispatch_reward_without_signature_twice() {
  let mut state = setup();
}

#[test]
#[available_gas(20000000)]
fn test_dispatch_reward_without_signature_invalid() {
  let mut state = setup();
}
