use rewards::rewards::interface::IRewardsTokens;
use debug::PrintTrait;
use starknet::testing;

use openzeppelin::account::AccountABIDispatcher;
use openzeppelin::tests::mocks::account_mocks::SnakeAccountMock;

// locals
use rewards::rewards::funds::RewardsFundsComponent::InternalTrait as RewardsFundsInternalTrait;
use rewards::rewards::tokens::RewardsTokensComponent::InternalTrait as RewardsTokensInternalTrait;
use rewards::rewards::data::RewardsDataComponent::InternalTrait as RewardsDataInternalTrait;

use super::mocks::rewards_tokens_mock::RewardsTokensMock;

use super::constants;
use super::utils;

use super::utils::partial_eq::RewardEq;

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
    public_key: constants::PUBLIC_KEY,
    expected_address: constants::SIGNER()
  );

  // setup ether - 0x2
  let ether_contract_address = utils::setup_ether(
    recipient: signer.contract_address,
    expected_address: constants::ETHER_2().contract_address
  );

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
fn test_reward() {
  let state = setup();

  assert(
    state.reward(reward_id: constants::VALID::REWARD_CHEAP_ID()) == constants::VALID::REWARD_CHEAP(),
    'Invalid reward'
  )
}
