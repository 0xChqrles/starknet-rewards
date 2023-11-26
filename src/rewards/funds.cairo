#[starknet::component]
mod RewardsFundsComponent {
  use openzeppelin::access::ownable::OwnableComponent;
  use openzeppelin::access::ownable::ownable::OwnableComponent::InternalTrait as OwnableInternalTrait;

  use openzeppelin::token::erc20::dual20::DualCaseERC20;
  use openzeppelin::token::erc20::dual20::DualCaseERC20Trait;

  // locals
  use rewards::rewards::data::RewardsDataComponent;
  use rewards::rewards::interface::IRewardsData;
  use rewards::rewards::data::RewardModelTrait;

  use rewards::rewards::interface;

  //
  // Storage
  //

  #[storage]
  struct Storage {
    // ETH address
    _ether_contract_address: starknet::ContractAddress,
  }

  //
  // Errors
  //

  mod Errors {
    const MINT_NOT_ALLOWED: felt252 = 'rewards.mint_not_allowed';
    const INVALID_REWARD_MODEL: felt252 = 'rewards.invalid_rewards_model';
  }

  //
  // IRewardsFunds
  //

  #[embeddable_as(RewardsFundsImpl)]
  impl RewardsFunds<
    TContractState,
    +HasComponent<TContractState>,
    impl Ownable: OwnableComponent::HasComponent<TContractState>,
    +Drop<TContractState>
  > of interface::IRewardsFunds<ComponentState<TContractState>> {
    fn withdraw(ref self: ComponentState<TContractState>, recipient: starknet::ContractAddress) {
      let owneable_component = get_dep_component_mut!(ref self, Ownable);

      // assert caller is the owner
      owneable_component.assert_only_owner();

      // withdraw funds
      let ether_contract_address_ = self._ether_contract_address.read();
      let ether = DualCaseERC20 { contract_address: ether_contract_address_ };

      let this = starknet::get_contract_address();

      // get current balance
      let balance = ether.balance_of(account: this);

      // withdraw the whole balance
      ether.transfer(:recipient, amount: balance);
    }
  }

  //
  // Internals
  //

  #[generate_trait]
  impl InternalImpl<
    TContractState,
    +HasComponent<TContractState>,
    impl RewardsData: RewardsDataComponent::HasComponent<TContractState>,
    +Drop<TContractState>
  > of InternalTrait<TContractState> {
    fn initializer(ref self: ComponentState<TContractState>, ether_contract_address_: starknet::ContractAddress) {
      self._ether_contract_address.write(ether_contract_address_);
    }

    fn _collect_reward_price(
      ref self: ComponentState<TContractState>,
      from: starknet::ContractAddress,
      reward_model_id: u128
    ) {
      let mut rewards_data_component = get_dep_component_mut!(ref self, RewardsData);

      // get reward model
      let reward_model = rewards_data_component.reward_model(:reward_model_id);

      // assert reward model is valid (thus it exists)
      assert(reward_model.is_valid(), Errors::INVALID_REWARD_MODEL);

      // collect reward model price
      let ether_contract_address_ = self._ether_contract_address.read();
      let ether = DualCaseERC20 { contract_address: ether_contract_address_ };

      let this = starknet::get_contract_address();

      ether.transfer_from(sender: from, recipient: this, amount: reward_model.price);
    }
  }
}
