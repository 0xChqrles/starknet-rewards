#[starknet::component]
mod RewardsTokensComponent {
  use array::SpanTrait;

  use openzeppelin::token::erc20::dual20::{ DualCaseERC20, DualCaseERC20Trait };

  use messages::messages::MessagesComponent;

  // locals
  use rewards::rewards::messages::RewardsMessagesComponent;

  use rewards::rewards::funds::RewardsFundsComponent;
  use rewards::rewards::funds::RewardsFundsComponent::InternalTrait as RewardsFundsInternalTrait;

  use rewards::rewards::data::RewardsDataComponent;
  use rewards::rewards::data::RewardsDataComponent::InternalTrait as RewardsDataInternalTrait;

  use rewards::rewards::interface;
  use rewards::rewards::interface::{ IRewardsMessages, Reward };

  //
  // Storage
  //

  #[storage]
  struct Storage {
    // reward ID -> starknet ID domain
    _rewards_owners: LegacyMap<u256, felt252>,
  }

  //
  // Errors
  //

  mod Errors {
    const MINT_NOT_ALLOWED: felt252 = 'rewards.mint_not_allowed';
  }

  //
  // IRulesTokens impl
  //

  #[embeddable_as(RewardsTokensImpl)]
  impl RewardsTokens<
    TContractState,
    +HasComponent<TContractState>,
    impl RewardsMessages: RewardsMessagesComponent::HasComponent<TContractState>,
    +MessagesComponent::HasComponent<TContractState>,
    impl RewardsFunds: RewardsFundsComponent::HasComponent<TContractState>,
    impl RewardsData: RewardsDataComponent::HasComponent<TContractState>,
    +Drop<TContractState>,
  > of interface::IRewardsTokens<ComponentState<TContractState>> {
    fn owner_of(self: @ComponentState<TContractState>, reward_id: u256) -> felt252 {
      self._rewards_owners.read(reward_id)
    }

    fn send_reward(
      ref self: ComponentState<TContractState>,
      to_domain: felt252,
      reward: Reward,
      signature: Span<felt252>
    ) -> u256 {
      let caller = starknet::get_caller_address();

      let mut rewards_messages_component = get_dep_component_mut!(ref self, RewardsMessages);
      let mut rewards_funds_component = get_dep_component_mut!(ref self, RewardsFunds);
      let mut rewards_data_component = get_dep_component_mut!(ref self, RewardsData);

      // verify signature
      if (signature.is_empty()) {
        // if no signature is supplied, make sure the caller is the giver
        assert(reward.reward_content.giver == caller, Errors::MINT_NOT_ALLOWED);
      } else {
        // verify and consume signature
        rewards_messages_component.consume_valid_reward_from(from: reward.reward_content.giver, :reward, :signature);
      }

      // collect reward price (will revert if reward model does not exists)
      rewards_funds_component._collect_reward_price(
        from: reward.reward_content.giver,
        reward_model_id: reward.reward_model_id
      );

      // add reward_content
      let reward_content_id = rewards_data_component._add_reward_content(reward_content: reward.reward_content);

      // compute token ID
      let token_id = u256 {
        low: reward.reward_model_id,
        high: reward_content_id,
      };

      // mint token
      self._add_reward(:to_domain, :token_id);

      // return token ID
      token_id
    }
  }

  //
  // Internals
  //

  #[generate_trait]
  impl InternalImpl<
    TContractState,
    +HasComponent<TContractState>,
    +Drop<TContractState>
  > of InternalTrait<TContractState> {
    fn _add_reward(ref self: ComponentState<TContractState>, to_domain: felt252, token_id: u256) {
      self._rewards_owners.write(token_id, to_domain);
    }
  }
}
