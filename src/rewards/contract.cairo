#[starknet::contract]
mod Rewards {
  use openzeppelin::access::ownable::OwnableComponent;
  use openzeppelin::upgrades::UpgradeableComponent;
  use openzeppelin::token::erc721::ERC721Component;
  use openzeppelin::introspection::src5::SRC5Component;

  use messages::messages::MessagesComponent;

  // locals
  use rewards::rewards::data::RewardsDataComponent;
  use rewards::rewards::tokens::RewardsTokensComponent;
  use rewards::rewards::messages::RewardsMessagesComponent;

  use rewards::rewards::interface;

  //
  // Components
  //

  component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
  component!(path: UpgradeableComponent, storage: upgradeable, event: UpgradeableEvent);
  component!(path: ERC721Component, storage: erc721, event: ERC721Event);
  component!(path: SRC5Component, storage: src5, event: SRC5Event);

  component!(path: MessagesComponent, storage: messages, event: MessagesEvent);

  component!(path: RewardsDataComponent, storage: rewards_data, event: RewardsDataEvent);
  component!(path: RewardsTokensComponent, storage: rewards_tokens, event: RewardsTokensEvent);
  component!(path: RewardsMessagesComponent, storage: rewards_messages, event: RewardsMessagesEvent);

  // Ownable
  #[abi(embed_v0)]
  impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
  impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

  // Upgradeable
  impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

  // ERC721
  #[abi(embed_v0)]
  impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
  #[abi(embed_v0)]
  impl ERC721MetadataImpl = ERC721Component::ERC721MetadataImpl<ContractState>;
  #[abi(embed_v0)]
  impl ERC721CamelOnlyImpl = ERC721Component::ERC721CamelOnlyImpl<ContractState>;
  impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

  // Rewards Data
  #[abi(embed_v0)]
  impl RewardsDataImpl = RewardsDataComponent::RewardsDataImpl<ContractState>;

  // Rewards Tokens
  #[abi(embed_v0)]
  impl RewardsTokensImpl = RewardsTokensComponent::RewardsTokensImpl<ContractState>;

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
    ERC721Event: ERC721Component::Event,

    #[flat]
    SRC5Event: SRC5Component::Event,

    #[flat]
    MessagesEvent: MessagesComponent::Event,

    #[flat]
    RewardsDataEvent: RewardsDataComponent::Event,

    #[flat]
    RewardsTokensEvent: RewardsTokensComponent::Event,

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
    erc721: ERC721Component::Storage,

    #[substorage(v0)]
    src5: SRC5Component::Storage,

    #[substorage(v0)]
    messages: MessagesComponent::Storage,

    #[substorage(v0)]
    rewards_data: RewardsDataComponent::Storage,

    #[substorage(v0)]
    rewards_tokens: RewardsTokensComponent::Storage,

    #[substorage(v0)]
    rewards_messages: RewardsMessagesComponent::Storage,
  }

  //
  // Modifiers
  //

  #[generate_trait]
  impl ModifierImpl of ModifierTrait {
    fn _only_owner(self: @ContractState) {
      self.ownable.assert_only_owner();
    }
  }

  //
  // Constructor
  //

  #[constructor]
  fn constructor(ref self: ContractState, owner_: starknet::ContractAddress) {
    self.ownable.initializer(owner: owner_);
  }

  //
  // Upgrade
  //

  #[external(v0)]
  fn upgrade(ref self: ContractState, new_class_hash: starknet::ClassHash) {
    // Modifiers
    self._only_owner();

    // Body

    // set new impl
    self.upgradeable._upgrade(:new_class_hash);
  }
}
