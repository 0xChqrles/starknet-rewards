#[starknet::contract]
mod RewardsTokens {
  use openzeppelin::access::ownable::Ownable;

  component!(path: Ownable, storage: ownable, event: OwnableEvent);

  #[abi(embed_v0)]
  impl OwnableImpl = Ownable::OwnableImpl<ContractState>;

  impl OwnableInternalImpl = Ownable::InternalImpl<ContractState>;

  // locals
  use rewards::rewards::interface;

  //
  // Storage
  //

  #[storage]
  struct Storage {
    #[substorage(v0)]
    ownable: Ownable::Storage,
  }

  //
  // Events
  //

  #[event]
  #[derive(Drop, starknet::Event)]
  enum Event {
    #[flat]
    OwnableEvent: Ownable::Event,
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

  // TODO: use Upgradeable impl with more custom call after upgrade

  #[generate_trait]
  #[external(v0)]
  impl UpgradeImpl of UpgradeTrait {
    fn upgrade(ref self: ContractState, new_implementation: starknet::ClassHash) {
      // Modifiers
      self._only_owner();

      // Body

      // set new impl
      starknet::replace_class_syscall(new_implementation);
    }
  }

  //
  // Rules Tokens impl
  //

  // #[external(v0)]
  // impl IRulesTokensImpl of interface::IRulesTokens<ContractState> {
  // }
}
