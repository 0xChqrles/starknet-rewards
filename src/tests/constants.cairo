use openzeppelin::token::erc20::dual20::DualCaseERC20;

// locals
use rewards::rewards::interface::{ RewardModel, RewardContent, RewardNote, Reward, RewardDispatch };

mod VALID {
  // locals
  use rewards::rewards::data::RewardModelTrait;

  use super::{
    RewardModel,
    RewardContent,
    RewardNote,
    Reward,
    RewardDispatch,
    SIGNER,
    SIGNER_3,
    DISPATCHER_1,
    DOMAIN_1,
    DOMAIN_2,
  };
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
        high: 'price high 1',
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

  fn REWARD_MODEL_CHEAP_ID() -> u128 {
    REWARD_MODEL_CHEAP().id()
  }

  fn REWARD_MODEL_FREE_ID() -> u128 {
    REWARD_MODEL_FREE().id()
  }

  // reward contents

  fn REWARD_CONTENT_1() -> RewardContent {
    RewardContent {
      dispatcher: SIGNER(),
      note: RewardNote {
        s1: 1,
        s2: 2,
      },
    }
  }

  fn REWARD_CONTENT_2() -> RewardContent {
    RewardContent {
      dispatcher: SIGNER_3(),
      note: RewardNote {
        s1: 's1',
        s2: 's2',
      },
    }
  }

  fn REWARD_CONTENT_EMPTY_NOTE() -> RewardContent {
    RewardContent {
      dispatcher: DISPATCHER_1(),
      note: RewardNoteZeroable::zero(),
    }
  }

  // Rewards

  fn REWARD_1() -> Reward {
    Reward {
      reward_content: REWARD_CONTENT_1(),
      reward_model_id: REWARD_MODEL_1_ID(),
    }
  }

  fn REWARD_CHEAP() -> Reward {
    Reward {
      reward_content: REWARD_CONTENT_1(),
      reward_model_id: REWARD_MODEL_CHEAP_ID(),
    }
  }

  fn REWARD_CHEAP_2() -> Reward {
    Reward {
      reward_content: REWARD_CONTENT_2(),
      reward_model_id: REWARD_MODEL_CHEAP_ID(),
    }
  }

  fn REWARD_1_ID() -> u256 {
    u256 {
      low: REWARD_1().reward_model_id,
      high: 1,
    }
  }

  fn REWARD_CHEAP_ID() -> u256 {
    u256 {
      low: REWARD_CHEAP().reward_model_id,
      high: 1,
    }
  }

  fn REWARD_CHEAP_2_ID() -> u256 {
    u256 {
      low: REWARD_CHEAP_2().reward_model_id,
      high: 2,
    }
  }

  // Rewards dispatch

  fn REWARD_DISPATCH_1() -> RewardDispatch {
    RewardDispatch {
      to_domain: DOMAIN_1,
      reward: REWARD_1(),
    }
  }

  fn REWARD_DISPATCH_CHEAP() -> RewardDispatch {
    RewardDispatch {
      to_domain: DOMAIN_1,
      reward: REWARD_CHEAP(),
    }
  }

  fn REWARD_DISPATCH_CHEAP_2() -> RewardDispatch {
    RewardDispatch {
      to_domain: DOMAIN_2,
      reward: REWARD_CHEAP_2(),
    }
  }

  // Signatures

  fn REWARD_DISPATCH_1_SIGNATURE() -> Span<felt252> {
    array![
      400701612205818067500795740381573555031969930447556177353353553926194722088,
      365364548298767573866700114516106005143784487059591208664227687992547483941,
    ].span()
  }

  fn REWARD_DISPATCH_CHEAP_SIGNATURE() -> Span<felt252> {
    array![
      1012090352051962097251154003260138393603512205569533230429964552334286545629,
      221569790028110632923996560170666419813127993290399810878702125813866923743,
    ].span()
  }

  fn REWARD_DISPATCH_CHEAP_2_SIGNATURE() -> Span<felt252> {
    array![
      1164691412215616427508234334966580023997906646778589796357011733393215428081,
      3303049157550811657856524758579704588191528573422978067890275736496774393053,
    ].span()
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

  fn REWARD_CONTENT_ZERO_DISPATCHER() -> RewardContent {
    RewardContent {
      dispatcher: ZERO(),
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

fn DISPATCHER_1() -> starknet::ContractAddress {
  starknet::contract_address_const::<'DISPATCHER_1'>()
}

fn ZERO() -> starknet::ContractAddress {
  starknet::contract_address_const::<0>()
}

fn FUNDS() -> starknet::ContractAddress {
  starknet::contract_address_const::<'FUNDS'>()
}

fn SIGNER() -> starknet::ContractAddress {
  starknet::contract_address_const::<1>()
}

fn SIGNER_3() -> starknet::ContractAddress {
  starknet::contract_address_const::<3>()
}

// contracts

fn ETHER(contract_address: starknet::ContractAddress) -> DualCaseERC20 {
  DualCaseERC20 { contract_address }
}

fn ETHER_1() -> DualCaseERC20 {
  ETHER(starknet::contract_address_const::<1>())
}

fn ETHER_2() -> DualCaseERC20 {
  ETHER(starknet::contract_address_const::<2>())
}

// misc

const CHAIN_ID: felt252 = 'SN_MAIN';

// private key = 4321
const SIGNER_PUBLIC_KEY: felt252 = 0x1766831fbcbc258a953dd0c0505ecbcd28086c673355c7a219bc031b710b0d6;

// private key = 1234
const SIGNER_3_PUBLIC_KEY: felt252 = 0x1f3c942d7f492a37608cde0d77b884a5aa9e11d2919225968557370ddb5a5aa;

const DOMAIN_1: felt252 = 'domain.stark';

const DOMAIN_2: felt252 = 'zebi.stark';
