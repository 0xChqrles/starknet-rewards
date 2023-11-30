use array::{ ArrayTrait, SpanSerde };

#[derive(Serde, Copy, Drop)]
struct RewardModel {
  name: felt252,
  image_hash: u256,
  price: u256,
}

#[derive(Serde, Copy, Drop)]
struct RewardContent {
  dispatcher: starknet::ContractAddress,
  note: RewardNote, // can be empty
}

#[derive(Serde, Copy, Drop)]
struct RewardNote {
  s1: felt252,
  s2: felt252,
}

#[derive(Serde, Copy, Drop)]
struct Reward {
  reward_model_id: u128,
  reward_content: RewardContent
}

#[derive(Serde, Copy, Drop)]
struct RewardDispatch {
  to_domain: felt252, // Starknet ID domain
  reward: Reward,
}

//
// Interfaces
//

#[starknet::interface]
trait IRewardsTokens<TState> {
  fn owner_of(self: @TState, reward_id: u256) -> felt252;

  fn dispatch_reward(ref self: TState, reward_dispatch: RewardDispatch, signature: Span<felt252>) -> u256;
}

#[starknet::interface]
trait IRewardsData<TState> {
  fn reward_model(self: @TState, reward_model_id: u128) -> RewardModel;

  fn reward_content(self: @TState, reward_content_id: u128) -> RewardContent;
}

#[starknet::interface]
trait IRewardsMessages<TState> {
  fn consume_valid_reward_dispatch(ref self: TState, reward_dispatch: RewardDispatch, signature: Span<felt252>);
}
