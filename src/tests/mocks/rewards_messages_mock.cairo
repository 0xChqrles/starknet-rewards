#[starknet::contract]
mod RewardsMessagesMock {
  use messages::messages::MessagesComponent;

  // locals
  use rewards::rewards::messages::RewardsMessagesComponent;

  //
  // Components
  //

  component!(path: RewardsMessagesComponent, storage: rewards_messages, event: RewardsMessagesEvent);
  component!(path: MessagesComponent, storage: messages, event: MessagesEvent);

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
    RewardsMessagesEvent: RewardsMessagesComponent::Event,

    #[flat]
    MessagesEvent: MessagesComponent::Event,
  }

  //
  // Storage
  //

  #[storage]
  struct Storage {
    #[substorage(v0)]
    rewards_messages: RewardsMessagesComponent::Storage,

    #[substorage(v0)]
    messages: MessagesComponent::Storage,
  }
}
