use core::zeroable::Zeroable;
use rewards::rewards::interface::IRewardsData;

use super::mocks::rewards_data_mock::RewardsDataMock;

use super::utils::partial_eq::RewardModelEq;
use super::utils::zeroable::RewardModelZeroable;

fn STATE() -> RewardsDataMock::ContractState {
  RewardsDataMock::contract_state_for_testing()
}

#[test]
#[available_gas(20000000)]
fn test_empty_rewards_model() {
  let state = @STATE();

  assert(state.reward_model(0).is_zero(), 'Should be null');
}
