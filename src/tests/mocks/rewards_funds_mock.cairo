#[starknet::contract]
mod RewardsFundsMock {
  // locals
  use rewards::rewards::funds::RewardsFundsComponent;
  use rewards::rewards::data::RewardsDataComponent;

  //
  // Components
  //

  component!(path: RewardsFundsComponent, storage: rewards_funds, event: RewardsFundsEvent);
  component!(path: RewardsDataComponent, storage: rewards_data, event: RewardsDataEvent);

  impl RewardsFundsInternalImpl = RewardsFundsComponent::InternalImpl<ContractState>;

  //
  // Events
  //

  #[event]
  #[derive(Drop, starknet::Event)]
  enum Event {
    #[flat]
    RewardsFundsEvent: RewardsFundsComponent::Event,

    #[flat]
    RewardsDataEvent: RewardsDataComponent::Event,
  }

  //
  // Storage
  //

  #[storage]
  struct Storage {
    #[substorage(v0)]
    rewards_funds: RewardsFundsComponent::Storage,

    #[substorage(v0)]
    rewards_data: RewardsDataComponent::Storage,
  }
}
