#[starknet::contract]
mod RewardsDataMock {
  // locals
  use rewards::rewards::data::RewardsDataComponent;

  //
  // Components
  //

  component!(path: RewardsDataComponent, storage: rewards_data, event: RewardsDataEvent);

  #[abi(embed_v0)]
  impl RewardsDataImpl = RewardsDataComponent::RewardsDataImpl<ContractState>;
  impl RewardsDataInternalImpl = RewardsDataComponent::InternalImpl<ContractState>;

  //
  // Events
  //

  #[event]
  #[derive(Drop, starknet::Event)]
  enum Event {
    #[flat]
    RewardsDataEvent: RewardsDataComponent::Event,
  }

  //
  // Storage
  //

  #[storage]
  struct Storage {
    #[substorage(v0)]
    rewards_data: RewardsDataComponent::Storage,
  }
}
