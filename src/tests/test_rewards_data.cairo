use zeroable::Zeroable;

use openzeppelin::introspection::src5::SRC5Component::SRC5Impl;

// locals
use rewards::rewards::interface::IRewardsData;
use rewards::rewards::data::RewardsDataComponent::InternalTrait as RewardsDataInternalTrait;

use super::mocks::rewards_data_mock::RewardsDataMock;

use super::utils::partial_eq::RewardModelEq;
use super::utils::zeroable::RewardModelZeroable;

use super::constants;

fn STATE() -> RewardsDataMock::ContractState {
  RewardsDataMock::contract_state_for_testing()
}

fn setup() -> RewardsDataMock::ContractState {
  let mut state = STATE();

  state.rewards_data._add_reward_model(constants::VALID::REWARD_MODEL_1());

  state
}

//
// Tests
//

#[test]
#[available_gas(20000000)]
fn test_empty_rewards_model() {
  let state = @STATE();

  assert(state.reward_model(0).is_zero(), 'Should be null');
}

#[test]
#[available_gas(20000000)]
fn test_rewards_model() {
  let state = @setup();

  assert(
    state.reward_model(constants::VALID::REWARD_MODEL_1_ID()) == constants::VALID::REWARD_MODEL_1(),
    'Invalid reward model'
  );
}
