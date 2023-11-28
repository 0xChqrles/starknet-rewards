#[starknet::contract]
mod Rewards {
  use openzeppelin::access::ownable::OwnableComponent;
  use openzeppelin::upgrades::UpgradeableComponent;

  use messages::messages::MessagesComponent;

  // locals
  use rewards::rewards::data::RewardsDataComponent;
  use rewards::rewards::tokens::RewardsTokensComponent;
  use rewards::rewards::funds::RewardsFundsComponent;
  use rewards::rewards::messages::RewardsMessagesComponent;

  use rewards::rewards::interface;

  use rewards::rewards::funds::RewardsFundsComponent::InternalTrait;

  //
  // Components
  //

  component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
  component!(path: UpgradeableComponent, storage: upgradeable, event: UpgradeableEvent);

  component!(path: MessagesComponent, storage: messages, event: MessagesEvent);

  component!(path: RewardsDataComponent, storage: rewards_data, event: RewardsDataEvent);
  component!(path: RewardsTokensComponent, storage: rewards_tokens, event: RewardsTokensEvent);
  component!(path: RewardsFundsComponent, storage: rewards_funds, event: RewardsFundsEvent);
  component!(path: RewardsMessagesComponent, storage: rewards_messages, event: RewardsMessagesEvent);

  // Ownable
  #[abi(embed_v0)]
  impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
  impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

  // Upgradeable
  impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

  // Rewards Data
  #[abi(embed_v0)]
  impl RewardsDataImpl = RewardsDataComponent::RewardsDataImpl<ContractState>;

  // Rewards Tokens
  #[abi(embed_v0)]
  impl RewardsTokensImpl = RewardsTokensComponent::RewardsTokensImpl<ContractState>;

  // Rewards Funds
  #[abi(embed_v0)]
  impl RewardsFundsImpl = RewardsFundsComponent::RewardsFundsImpl<ContractState>;

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
    OwnableEvent: OwnableComponent::Event,

    #[flat]
    UpgradeableEvent: UpgradeableComponent::Event,

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
    ownable: OwnableComponent::Storage,

    #[substorage(v0)]
    upgradeable: UpgradeableComponent::Storage,

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

  //
  // Constructor
  //

  #[constructor]
  fn constructor(
    ref self: ContractState,
    owner: starknet::ContractAddress,
    ether_contract_address_: starknet::ContractAddress
  ) {
    self.ownable.initializer(:owner);
    self.rewards_funds.initializer(:ether_contract_address_);
  }

  //
  // Upgrade
  //

  #[external(v0)]
  fn upgrade(ref self: ContractState, new_class_hash: starknet::ClassHash) {
    // Modifiers
    self.ownable.assert_only_owner();

    // Body

    // set new impl
    self.upgradeable._upgrade(:new_class_hash);
  }
}
