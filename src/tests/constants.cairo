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
        low: 'image low 1',
        high: 'image high 1',
      },
      price: u256 {
        low: 'price low 1',
        high: 'price low 1',
      },
    }
  }

  fn REWARD_MODEL_1_ID() -> u128 {
    REWARD_MODEL_1().id()
  }

  fn REWARD_MODEL_2() -> RewardModel {
    RewardModel {
      name: 'reward 2',
      image_hash: u256 {
        low: 'image low 2',
        high: 'image high 2',
      },
      price: u256 {
        low: 'price low 2',
        high: 'price low 2',
      },
    }
  }

  fn REWARD_MODEL_2_ID() -> u128 {
    REWARD_MODEL_2().id()
  }

  fn REWARD_MODEL_FREE() -> RewardModel {
    RewardModel {
      name: 1,
      image_hash: 1,
      price: 0,
    }
  }

  fn REWARD_MODEL_FREE_ID() -> u128 {
    REWARD_MODEL_FREE().id()
  }
}

mod INVALID {
  // locals
  use rewards::rewards::data::RewardModelTrait;

  use super::RewardModel;

  fn REWARD_MODEL_NO_IMAGE() -> RewardModel {
    RewardModel {
      name: 1,
      image_hash: 0,
      price: 1
    }
  }

  fn REWARD_MODEL_NO_NAME() -> RewardModel {
    RewardModel {
      name: 0,
      image_hash: 1,
      price: 1,
    }
  }
}

fn OWNER() -> starknet::ContractAddress {
  starknet::contract_address_const::<'OWNER'>()
}
