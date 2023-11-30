use core::debug::PrintTrait;
use hash::HashStateTrait;
use traits::Into;
use poseidon::PoseidonTrait;
use zeroable::Zeroable;

// locals
use rewards::rewards::interface::{ RewardModel, RewardContent };

#[starknet::component]
mod RewardsDataComponent {
  // locals
  use rewards::utils::storage::{ StoreRewardModel, StoreRewardContent };

  use super::{ RewardModel, RewardModelTrait, RewardContent, RewardContentTrait };

  use rewards::rewards::interface;

  //
  // Storage
  //

  #[storage]
  struct Storage {
    // reward_model_id -> RewardModel
    _reward_models: LegacyMap<u128, RewardModel>,
    // reward_model_id -> RewardModel
    _reward_contents: LegacyMap<u128, RewardContent>,
    // used to generate reward contents ids
    _reward_contents_count: u128,
  }

  //
  // Errors
  //

  mod Errors {
    const INVALID_REWARD_CONTENT: felt252 = 'data.invalid_reward_content';
    const INVALID_REWARD_MODEL: felt252 = 'data.invalid_reward_model';
  }

  //
  // IRulesData impl
  //

  #[embeddable_as(RewardsDataImpl)]
  impl RewardsData<
    TContractState,
    +HasComponent<TContractState>,
    +Drop<TContractState>,
  > of interface::IRewardsData<ComponentState<TContractState>> {
    fn reward_model(self: @ComponentState<TContractState>, reward_model_id: u128) -> RewardModel {
      self._reward_models.read(reward_model_id)
    }

    fn reward_content(self: @ComponentState<TContractState>, reward_content_id: u128) -> RewardContent {
      self._reward_contents.read(reward_content_id)
    }
  }

  //
  // Internals
  //

  #[generate_trait]
  impl InternalImpl<
    TContractState,
    +HasComponent<TContractState>,
    +Drop<TContractState>
  > of InternalTrait<TContractState> {
    fn _add_reward_content(ref self: ComponentState<TContractState>, reward_content: RewardContent) -> u128 {
      // assert reward content is valid
      assert(reward_content.is_valid(), Errors::INVALID_REWARD_CONTENT);

      // increase reward model count
      let mut reward_contents_count_ = self._reward_contents_count.read() + 1;
      self._reward_contents_count.write(reward_contents_count_);

      // store reward content
      let reward_content_id = reward_contents_count_;
      self._reward_contents.write(reward_content_id, reward_content);

      reward_content_id
    }

    fn _add_reward_model(ref self: ComponentState<TContractState>, reward_model: RewardModel) -> u128 {
      // assert reward model is valid
      assert(reward_model.is_valid(), Errors::INVALID_REWARD_MODEL);

      // compute reward model id
      let reward_model_id = reward_model.id();

      // store reward model
      self._reward_models.write(reward_model_id, reward_model);

      // return reward model id
      reward_model_id
    }
  }
}

// Reward Model trait

trait RewardModelTrait {
  fn is_valid(self: RewardModel) -> bool;

  fn id(self: RewardModel) -> u128;
}

impl RewardModelImpl of RewardModelTrait {
  fn is_valid(self: RewardModel) -> bool {
    // allow reward models with a null price
    if (self.name.is_zero() | self.image_hash.is_zero()) {
      false
    } else {
      true
    }
  }

  fn id(self: RewardModel) -> u128 {
    let mut hash_state = PoseidonTrait::new();

    hash_state = hash_state.update(self.name);
    hash_state = hash_state.update(self.image_hash.low.into());
    hash_state = hash_state.update(self.image_hash.high.into());
    hash_state = hash_state.update(self.price.low.into());
    hash_state = hash_state.update(self.price.high.into());

    let hash = hash_state.finalize();

    Into::<felt252, u256>::into(hash).low
  }
}

trait RewardContentTrait {
  fn is_valid(self: RewardContent) -> bool;
}

impl RewardContentImpl of RewardContentTrait {
  fn is_valid(self: RewardContent) -> bool {
    // allow reward contents with an empty note
    !self.giver.is_zero()
  }
}
