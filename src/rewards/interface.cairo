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

//
// Interfaces
//

#[starknet::interface]
trait IRewardsTokens<TState> {
  fn owner_of(self: @TState, reward_id: u256) -> felt252;

  fn send_reward(ref self: TState, to_domain: felt252, reward: Reward, signature: Span<felt252>) -> u256;
}

#[starknet::interface]
trait IRewardsData<TState> {
  fn reward_model(self: @TState, reward_model_id: u128) -> RewardModel;

  fn add_reward_model(ref self: TState, reward_model: RewardModel) -> u128;
}

#[starknet::interface]
trait IRewardsMessages<TState> {
  fn consume_valid_reward_from(
    ref self: TState,
    from: starknet::ContractAddress,
    reward: Reward,
    signature: Span<felt252>
  );
}

#[starknet::interface]
trait IRewardsFunds<TState> {
  fn withdraw(ref self: TState, recipient: starknet::ContractAddress);
}
