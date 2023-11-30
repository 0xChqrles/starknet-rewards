#[starknet::contract]
mod RewardsTokensMock {
  use messages::messages::MessagesComponent;

  // locals
  use rewards::rewards::data::RewardsDataComponent;
  use rewards::rewards::tokens::RewardsTokensComponent;
  use rewards::rewards::funds::RewardsFundsComponent;
  use rewards::rewards::messages::RewardsMessagesComponent;

  use rewards::rewards::funds::RewardsFundsComponent::InternalTrait as RewardsFundsInternalTrait;
  use rewards::rewards::data::RewardsDataComponent::InternalTrait as RewardsDataInternalTrait;

  use rewards::rewards::interface;
  use rewards::rewards::interface::RewardModel;

  //
  // Components
  //

  component!(path: MessagesComponent, storage: messages, event: MessagesEvent);

  component!(path: RewardsDataComponent, storage: rewards_data, event: RewardsDataEvent);
  component!(path: RewardsTokensComponent, storage: rewards_tokens, event: RewardsTokensEvent);
  component!(path: RewardsFundsComponent, storage: rewards_funds, event: RewardsFundsEvent);
  component!(path: RewardsMessagesComponent, storage: rewards_messages, event: RewardsMessagesEvent);

  // Rewards Data
  #[abi(embed_v0)]
  impl RewardsDataImpl = RewardsDataComponent::RewardsDataImpl<ContractState>;
  impl RewardsDataInternalImpl = RewardsDataComponent::InternalImpl<ContractState>;

  // Rewards Tokens
  #[abi(embed_v0)]
  impl RewardsTokensImpl = RewardsTokensComponent::RewardsTokensImpl<ContractState>;

  // Rewards Funds
  impl RewardsFundsInternalImpl = RewardsFundsComponent::InternalImpl<ContractState>;

  // Rewards Messages
  #[abi(embed_v0)]
  impl RewardsMessagesImpl = RewardsMessagesComponent::RewardsMessagesImpl<ContractState>;

  //
  // Events
  //

  #[event]
  #[derive(Drop, starknet::Event)]
  enum Event {
    #[flat]
    MessagesEvent: MessagesComponent::Event,

    #[flat]
    RewardsDataEvent: RewardsDataComponent::Event,

    #[flat]
    RewardsTokensEvent: RewardsTokensComponent::Event,

    #[flat]
    RewardsFundsEvent: RewardsFundsComponent::Event,

    #[flat]
    RewardsMessagesEvent: RewardsMessagesComponent::Event,
  }

  //
  // Storage
  //

  #[storage]
  struct Storage {
    #[substorage(v0)]
    messages: MessagesComponent::Storage,

    #[substorage(v0)]
    rewards_data: RewardsDataComponent::Storage,

    #[substorage(v0)]
    rewards_tokens: RewardsTokensComponent::Storage,

    #[substorage(v0)]
    rewards_funds: RewardsFundsComponent::Storage,

    #[substorage(v0)]
    rewards_messages: RewardsMessagesComponent::Storage,
  }
}
