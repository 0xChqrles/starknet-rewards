use rewards::rewards::interface::IRewardsTokens;
use debug::PrintTrait;
use starknet::testing;

use openzeppelin::account::AccountABIDispatcher;
use openzeppelin::tests::mocks::account_mocks::SnakeAccountMock;

// locals
use rewards::rewards::tokens::RewardsTokensComponent::InternalTrait as RewardsTokensInternalTrait;

use super::mocks::rewards_tokens_mock::RewardsTokensMock;

use super::constants;
use super::utils;

use rewards::typed_data::rewards::RewardDispatch;

fn STATE() -> RewardsTokensMock::ContractState {
  RewardsTokensMock::contract_state_for_testing()
}

// fn setup() -> RewardsTokensMock::ContractState {
//   let mut state = STATE();

//   state.send_reward(to_domain: constants::DOMAIN_1(), reward: constants::VALID::REWARD_1(), signature: constants::VALID::REWARD_1_SIGNATURE());

//   state
// }

// //
// // Tests
// //

// #[test]
// #[available_gas(20000000)]
// fn test_owner_of() {
//   let state = setup();

//   assert(state.owner_of(constants::REWARD_1_ID()) == constants::DOMAIN_1(), 'Invalid owner')
// }
