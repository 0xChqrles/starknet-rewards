use array::{ ArrayTrait, SpanSerde };

#[derive(Serde, Copy, Drop)]
struct RewardModel {
  name: felt252,
  image_hash: u256,
  price: u256,
}

#[derive(Serde, Copy, Drop)]
struct RewardContent {
  giver: starknet::ContractAddress,
  message: Span<felt252>, // can be empty
}

#[derive(Serde, Copy, Drop)]
struct Reward {
  reward_model_id: u128,
  reward_content: RewardContent
}

//
// Interfaces
//

#[starknet::interface]
trait IRewardsTokens<TContractState> {
  fn mint_reward(
    ref self: TContractState,
    to: starknet::ContractAddress,
    reward: Reward,
    signature: Span<felt252>
  ) -> Span<felt252>;
}

#[starknet::interface]
trait IRewardsData<TContractState> {
  fn reward_model(self: @TContractState, reward_model_id: u128) -> RewardModel;

  fn add_reward_model(ref self: TContractState, reward_model: RewardModel) -> u128;
}

#[starknet::interface]
trait IRewardsMessages<TContractState> {
  fn consume_valid_reward_from(
    ref self: TContractState,
    from: starknet::ContractAddress,
    reward: Reward,
    signature: Span<felt252>
  ) -> felt252;
}
