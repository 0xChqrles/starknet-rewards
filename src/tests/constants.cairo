// locals
use rewards::rewards::interface::RewardModel;

mod VALID {
  // locals
  use rewards::rewards::data::RewardModelTrait;

  use super::RewardModel;

  fn REWARD_MODEL_1() -> RewardModel {
    RewardModel {
      name: 'reward 1',
      image_hash: u256 {
        low: 'low1',
        high: 'high2',
      },
      price: u256 {
        low: 'low3',
        high: 'high4',
      },
    }
  }

  fn REWARD_MODEL_1_ID() -> u128 {
    REWARD_MODEL_1().id()
  }
}

fn OWNER() -> starknet::ContractAddress {
  starknet::contract_address_const::<'OWNER'>()
}
