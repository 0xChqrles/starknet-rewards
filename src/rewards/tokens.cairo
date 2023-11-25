#[starknet::component]
mod RewardsTokensComponent {
  use openzeppelin::token::erc721::ERC721Component;
  use openzeppelin::token::erc721::ERC721Component::InternalTrait as ERC721InternalTrait;

  // mandatory if you want to have access to ERC721 internals
  use openzeppelin::introspection::src5::SRC5Component;

  // locals
  use rewards::utils::storage::StoreRewardContent;
  use rewards::rewards::interface;
  use rewards::rewards::interface::{ Reward, RewardContent };

  //
  // Storage
  //

  #[storage]
  struct Storage {
    // reward_model_id -> RewardModel
    _reward_contents: LegacyMap<u128, RewardContent>,
    // used to generate reward contents ids
    _reward_contents_count: u128,
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
    +Drop<TContractState>
  > of interface::IRewardsTokens<ComponentState<TContractState>> {
    fn mint_reward(
      ref self: ComponentState<TContractState>,
      to: starknet::ContractAddress,
      reward: Reward,
      signature: Span<felt252>
    ) -> u256 {
      // TODO: verify calldata

      // increase reward model count
      let mut reward_contents_count_ = self._reward_contents_count.read() + 1;
      self._reward_contents_count.write(reward_contents_count_);

      // store reward content
      let reward_content_id = reward_contents_count_;
      self._reward_contents.write(reward_content_id, reward.reward_content);

      // compute token ID
      let token_id = u256 {
        low: reward.reward_model_id,
        high: reward_contents_count_,
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
    impl SRC5: SRC5Component::HasComponent<TContractState>,
    +Drop<TContractState>
  > of InternalTrait<TContractState> {
    fn _mint(ref self: ComponentState<TContractState>, to: starknet::ContractAddress, token_id: u256) {
      let mut erc721_component = get_dep_component_mut!(ref self, ERC721);

      erc721_component._mint(:to, :token_id);
    }
  }
}
