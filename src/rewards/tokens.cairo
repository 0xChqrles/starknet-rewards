#[starknet::component]
mod RewardsTokensComponent {
  use openzeppelin::token::erc20::dual20::DualCaseERC20Trait;
use core::array::SpanTrait;

  use openzeppelin::token::erc721::ERC721Component;
  use openzeppelin::token::erc721::ERC721Component::InternalTrait as ERC721InternalTrait;

  use openzeppelin::introspection::src5::SRC5Component;

  use openzeppelin::token::erc20::dual20::DualCaseERC20;

  use messages::messages::MessagesComponent;

  // locals
  use rewards::rewards::messages::RewardsMessagesComponent;
  use rewards::rewards::interface::IRewardsMessages;

  use rewards::rewards::data::RewardsDataComponent;
  use rewards::rewards::data::RewardModelTrait;
  use rewards::rewards::interface::IRewardsData;

  use rewards::utils::storage::StoreRewardContent;
  use rewards::rewards::interface;
  use rewards::rewards::interface::{ Reward, RewardContent };

  //
  // Storage
  //

  #[storage]
  struct Storage {
    // ETH address
    _ether_contract_address: starknet::ContractAddress,

    // reward_model_id -> RewardModel
    _reward_contents: LegacyMap<u128, RewardContent>,
    // used to generate reward contents ids
    _reward_contents_count: u128,
  }

  //
  // Errors
  //

  mod Errors {
    const MINT_NOT_ALLOWED: felt252 = 'rewards.mint_not_allowed';
    const INVALID_REWARD_MODEL: felt252 = 'rewards.invalid_rewards_model';
  }

  //
  // IRulesTokens impl
  //

  #[embeddable_as(RewardsTokensImpl)]
  impl RewardsTokens<
    TContractState,
    +HasComponent<TContractState>,
    +ERC721Component::HasComponent<TContractState>,
    +SRC5Component::HasComponent<TContractState>,
    impl RewardsMessages: RewardsMessagesComponent::HasComponent<TContractState>,
    +MessagesComponent::HasComponent<TContractState>,
    +RewardsDataComponent::HasComponent<TContractState>,
    +Drop<TContractState>
  > of interface::IRewardsTokens<ComponentState<TContractState>> {
    fn mint_reward(
      ref self: ComponentState<TContractState>,
      to: starknet::ContractAddress,
      reward: Reward,
      signature: Span<felt252>
    ) -> u256 {
      let caller = starknet::get_caller_address();
      let mut rewards_messages_component = get_dep_component_mut!(ref self, RewardsMessages);

      // verify signature
      if (signature.is_empty()) {
        // if no signature is supplied, make sure the caller is the giver
        assert(reward.reward_content.giver == caller, Errors::MINT_NOT_ALLOWED);
      } else {
        // verify and consume signature
        rewards_messages_component.consume_valid_reward_from(from: reward.reward_content.giver, :reward, :signature);
      }

      // collect reward price (will revert if reward model does not exists)
      self._collect_reward_price(from: reward.reward_content.giver, reward_model_id: reward.reward_model_id);

      // add reward_content
      let reward_content_id = self._add_reward_content(reward_content: reward.reward_content);

      // compute token ID
      let token_id = u256 {
        low: reward.reward_model_id,
        high: reward_content_id,
      };

      // mint token
      self._mint(:to, :token_id);

      // return token ID
      token_id
    }
  }

  #[generate_trait]
  impl InternalImpl<
    TContractState,
    +HasComponent<TContractState>,
    impl ERC721: ERC721Component::HasComponent<TContractState>,
    +SRC5Component::HasComponent<TContractState>,
    impl RewardsData: RewardsDataComponent::HasComponent<TContractState>,
    +Drop<TContractState>
  > of InternalTrait<TContractState> {
    fn _set_ether_contract_address(ref self: ComponentState<TContractState>, token_address: starknet::ContractAddress) {
      self._ether_contract_address.write(token_address);
    }

    fn _mint(ref self: ComponentState<TContractState>, to: starknet::ContractAddress, token_id: u256) {
      let mut erc721_component = get_dep_component_mut!(ref self, ERC721);

      erc721_component._safe_mint(:to, :token_id, data: array![].span());
    }

    fn _add_reward_content(ref self: ComponentState<TContractState>, reward_content: RewardContent) -> u128 {
      // increase reward model count
      let mut reward_contents_count_ = self._reward_contents_count.read() + 1;
      self._reward_contents_count.write(reward_contents_count_);

      // store reward content
      let reward_content_id = reward_contents_count_;
      self._reward_contents.write(reward_content_id, reward_content);

      reward_content_id
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
