#[starknet::component]
mod RewardsFundsComponent {
  use core::zeroable::Zeroable;
use core::debug::PrintTrait;
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
    const INVALID_REWARD_MODEL: felt252 = 'funds.invalid_rewards_model';
    const WITHDRAW_TO_ZERO: felt252 = 'funds.withdraw_to_zero';
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

    fn _withdraw(ref self: ComponentState<TContractState>, recipient: starknet::ContractAddress) {
      // assert the recipient is not null
      assert(recipient.is_non_zero(), Errors::WITHDRAW_TO_ZERO);

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
}
