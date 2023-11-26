use messages::typed_data::typed_data::Domain;

fn DOMAIN() -> Domain {
  Domain {
    name: 'Rewards',
    version: '1.0',
  }
}

#[starknet::component]
mod RewardsMessagesComponent {
  use messages::typed_data::TypedDataTrait;
  use messages::messages::messages::MessagesComponent::InternalTrait;
  use messages::messages::MessagesComponent;
  use messages::messages::MessagesComponent::InternalImpl as MessagesInternalImpl;

  // locals
  use rewards::rewards::interface;
  use rewards::rewards::interface::Reward;
  use rewards::typed_data::rewards::RewardMessage;

  use super::DOMAIN;

  //
  // Storage
  //

  #[storage]
  struct Storage {}

  //
  // IRewardsMessages
  //

  #[embeddable_as(RewardsMessagesImpl)]
  impl RewardsMessages<
    TContractState,
    +HasComponent<TContractState>,
    impl Messages: MessagesComponent::HasComponent<TContractState>,
    +Drop<TContractState>
  > of interface::IRewardsMessages<ComponentState<TContractState>> {
    fn consume_valid_reward_from(
      ref self: ComponentState<TContractState>,
      from: starknet::ContractAddress,
      reward: Reward,
      signature: Span<felt252>
    ) {
      let mut messages_component = get_dep_component_mut!(ref self, Messages);

      // compute voucher message hash
      let hash = reward.compute_hash_from(:from, domain: DOMAIN());

      // assert voucher has not been already consumed and consume it
      assert(!messages_component._is_message_consumed(:hash), 'Reward already consumed');
      messages_component._consume_message(:hash);

      // assert voucher signature is valid
      assert(
        messages_component._is_message_signature_valid(:hash, :signature, signer: from),
        'Invalid reward signature'
      );
    }
  }
}
