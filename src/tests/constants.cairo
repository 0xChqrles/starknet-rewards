use openzeppelin::token::erc20::dual20::DualCaseERC20;

// locals
use rewards::rewards::interface::{ RewardModel, RewardContent, RewardNote };

mod VALID {
  // locals
  use rewards::rewards::data::RewardModelTrait;

  use super::{ RewardModel, RewardContent, RewardNote, GIVER_1, GIVER_2 };
  use super::super::utils::zeroable::RewardNoteZeroable;

  // reward models

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

  fn REWARD_MODEL_CHEAP() -> RewardModel {
    RewardModel {
      name: 1,
      image_hash: 1,
      price: 1_000,
    }
  }

  fn REWARD_MODEL_FREE() -> RewardModel {
    RewardModel {
      name: 1,
      image_hash: 1,
      price: 0,
    }
  }

  fn REWARD_MODEL_1_ID() -> u128 {
    REWARD_MODEL_1().id()
  }

  fn REWARD_MODEL_2_ID() -> u128 {
    REWARD_MODEL_2().id()
  }

  fn REWARD_MODEL_FREE_ID() -> u128 {
    REWARD_MODEL_FREE().id()
  }

  // reward contents

  fn REWARD_CONTENT_1() -> RewardContent {
    RewardContent {
      giver: GIVER_1(),
      note: RewardNote {
        s1: 1,
        s2: 2,
      },
    }
  }

  fn REWARD_CONTENT_2() -> RewardContent {
    RewardContent {
      giver: GIVER_2(),
      note: RewardNote {
        s1: 's1',
        s2: 's2',
      },
    }
  }

  fn REWARD_CONTENT_EMPTY_NOTE() -> RewardContent {
    RewardContent {
      giver: GIVER_1(),
      note: RewardNoteZeroable::zero(),
    }
  }
}

mod INVALID {
  // locals
  use super::{ RewardModel, RewardContent, RewardNote, ZERO };

  // reward models

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

  // reward contents

  fn REWARD_CONTENT_ZERO_GIVER() -> RewardContent {
    RewardContent {
      giver: ZERO(),
      note: RewardNote {
        s1: 1,
        s2: 1,
      },
    }
  }
}

// addresses

fn OWNER() -> starknet::ContractAddress {
  starknet::contract_address_const::<'OWNER'>()
}

fn GIVER_1() -> starknet::ContractAddress {
  starknet::contract_address_const::<'GIVER_1'>()
}

fn GIVER_2() -> starknet::ContractAddress {
  starknet::contract_address_const::<'GIVER_2'>()
}

fn ZERO() -> starknet::ContractAddress {
  starknet::contract_address_const::<0>()
}

fn FUNDS() -> starknet::ContractAddress {
  starknet::contract_address_const::<'FUNDS'>()
}

// contracts

fn ETHER() -> DualCaseERC20 {
  DualCaseERC20 { contract_address: starknet::contract_address_const::<1>() }
}
