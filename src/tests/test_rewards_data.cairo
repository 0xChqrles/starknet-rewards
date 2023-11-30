use debug::PrintTrait;
use zeroable::Zeroable;

use openzeppelin::introspection::src5::SRC5Component::SRC5Impl;

// locals
use rewards::rewards::interface::IRewardsData;
use rewards::rewards::data::RewardsDataComponent::InternalTrait as RewardsDataInternalTrait;

use super::mocks::rewards_data_mock::RewardsDataMock;

use super::utils::partial_eq::{ RewardModelEq, RewardContentEq };
use super::utils::zeroable::{ RewardModelZeroable, RewardContentZeroable };

use super::constants;

fn STATE() -> RewardsDataMock::ContractState {
  RewardsDataMock::contract_state_for_testing()
}

fn setup() -> RewardsDataMock::ContractState {
  let mut state = STATE();

  state.rewards_data._add_reward_model(constants::VALID::REWARD_MODEL_1());
  state.rewards_data._add_reward_content(constants::VALID::REWARD_CONTENT_1());

  state
}

//
// Tests
//

#[test]
#[available_gas(20000000)]
fn test_empty_reward_model() {
  let state = @STATE();

  assert(state.reward_model(0).is_zero(), 'Should be null');
}

#[test]
#[available_gas(20000000)]
fn test_reward_model() {
  let state = @setup();

  assert(
    state.reward_model(constants::VALID::REWARD_MODEL_1_ID()) == constants::VALID::REWARD_MODEL_1(),
    'Invalid reward model'
  );
}

#[test]
#[available_gas(20000000)]
fn test__add_reward_model() {
  let mut state = setup();

  // add reward model
  let rewards_model_id = state.rewards_data._add_reward_model(constants::VALID::REWARD_MODEL_2());

  assert(rewards_model_id == constants::VALID::REWARD_MODEL_2_ID(), 'Invalid reward model ID');
  assert(
    state.reward_model(constants::VALID::REWARD_MODEL_2_ID()) == constants::VALID::REWARD_MODEL_2(),
    'Invalid reward model'
  );
}

#[test]
#[available_gas(20000000)]
fn test__add_reward_model_free() {
  let mut state = setup();

  // add reward model
  let rewards_model_id = state.rewards_data._add_reward_model(constants::VALID::REWARD_MODEL_FREE());

  assert(rewards_model_id == constants::VALID::REWARD_MODEL_FREE_ID(), 'Invalid reward model ID');
  assert(
    state.reward_model(constants::VALID::REWARD_MODEL_FREE_ID()) == constants::VALID::REWARD_MODEL_FREE(),
    'Invalid reward model'
  );
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('data.invalid_reward_model',))]
fn test__add_reward_model_invalid_image() {
  let mut state = setup();

  // add reward model
  let rewards_model_id = state.rewards_data._add_reward_model(constants::INVALID::REWARD_MODEL_NO_IMAGE());
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('data.invalid_reward_model',))]
fn test__add_reward_model_invalid_name() {
  let mut state = setup();

  // add reward model
  let rewards_model_id = state.rewards_data._add_reward_model(constants::INVALID::REWARD_MODEL_NO_NAME());
}

// Reward content

#[test]
#[available_gas(20000000)]
fn test_empty_reward_content() {
  let state = @STATE();

  assert(state.reward_content(0).is_zero(), 'Should be null');
}

#[test]
#[available_gas(20000000)]
fn test_reward_content() {
  let state = @setup();

  assert(
    state.reward_content(1) == constants::VALID::REWARD_CONTENT_1(),
    'Invalid reward model'
  );
}

#[test]
#[available_gas(20000000)]
fn test__add_reward_content() {
  let mut state = setup();

  // add reward content
  let rewards_content_id = state.rewards_data._add_reward_content(constants::VALID::REWARD_CONTENT_2());

  assert(rewards_content_id == 2, 'Invalid reward content ID');
  assert(
    state.reward_content(rewards_content_id) == constants::VALID::REWARD_CONTENT_2(),
    'Invalid reward content'
  );
}

#[test]
#[available_gas(20000000)]
fn test__add_reward_content_empty_note() {
  let mut state = setup();

  // add reward content
  let rewards_content_id = state.rewards_data._add_reward_content(constants::VALID::REWARD_CONTENT_EMPTY_NOTE());

  assert(rewards_content_id == 2, 'Invalid reward content ID');
  assert(
    state.reward_content(rewards_content_id) == constants::VALID::REWARD_CONTENT_EMPTY_NOTE(),
    'Invalid reward content'
  );
}

#[test]
#[available_gas(20000000)]
#[should_panic(expected: ('data.invalid_reward_content',))]
fn test__add_reward_content_zero_dispatcher() {
  let mut state = setup();

  // add reward content
  let rewards_content_id = state.rewards_data._add_reward_content(constants::INVALID::REWARD_CONTENT_ZERO_DISPATCHER());
}
