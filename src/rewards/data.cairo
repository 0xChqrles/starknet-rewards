use hash::HashStateTrait;
use traits::Into;
use poseidon::PoseidonTrait;
use zeroable::Zeroable;

// locals
use rewards::rewards::interface::RewardModel;

#[starknet::component]
mod RewardsDataComponent {
  // locals
  use rewards::utils::storage::StoreRewardModel;

  use super::{ RewardModel, RewardModelTrait};

  use rewards::rewards::interface;

  //
  // Storage
  //

  #[storage]
  struct Storage {
    // reward_model_id -> RewardModel
    _reward_models: LegacyMap<u128, RewardModel>,
  }

  //
  // IRulesData impl
  //

  #[embeddable_as(RewardsDataImpl)]
  impl RewardsData<
    TContractState, +HasComponent<TContractState>
  > of interface::IRewardsData<ComponentState<TContractState>> {
    fn reward_model(self: @ComponentState<TContractState>, reward_model_id: u128) -> RewardModel {
      self._reward_models.read(reward_model_id)
    }

    fn add_reward_model(ref self: ComponentState<TContractState>, reward_model: RewardModel) -> u128 {
      // assert reward model is valid
      assert(reward_model.is_valid(), 'invalid.reward_model');

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
    if (self.name.is_zero() | self.price.is_zero() | self.image_hash.is_zero()) {
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
