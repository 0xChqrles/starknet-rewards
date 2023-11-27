#[starknet::component]
mod ERC721SoulboundComponent {
  use openzeppelin::token::erc721::ERC721Component;
  use openzeppelin::token::erc721::ERC721Component::ERC721MetadataImpl as ERC721SoulboundMetadataImpl;

  use openzeppelin::introspection::src5::SRC5Component;

  use openzeppelin::token::erc721::interface::{ IERC721, IERC721CamelOnly };

  // locals
  use rewards::token::interface;

  //
  // Storage
  //

  #[storage]
  struct Storage {}

  //
  // IERC721Soulbound
  //

  #[embeddable_as(ERC721SoulboundImpl)]
  impl ERC721Soulbound<
    TContractState,
    +HasComponent<TContractState>,
    impl ERC721: ERC721Component::HasComponent<TContractState>,
    +SRC5Component::HasComponent<TContractState>,
    +Drop<TContractState>,
  > of interface::IERC721Soulbound<ComponentState<TContractState>> {
    fn balance_of(self: @ComponentState<TContractState>, account: starknet::ContractAddress) -> u256 {
      let contract = self.get_contract();
      ERC721::get_component(contract).balance_of(:account)
    }

    fn owner_of(self: @ComponentState<TContractState>, token_id: u256) -> starknet::ContractAddress {
      let contract = self.get_contract();
      ERC721::get_component(contract).owner_of(:token_id)
    }
  }

  //
  // IERC721Soulbound
  //

  #[embeddable_as(ERC721SoulboundCamelOnlyImpl)]
  impl ERC721SoulboundCamelOnly<
    TContractState,
    +HasComponent<TContractState>,
    impl ERC721: ERC721Component::HasComponent<TContractState>,
    +SRC5Component::HasComponent<TContractState>,
    +Drop<TContractState>,
  > of interface::IERC721SoulboundCamelOnly<ComponentState<TContractState>> {
    fn balanceOf(self: @ComponentState<TContractState>, account: starknet::ContractAddress) -> u256 {
      let contract = self.get_contract();
      ERC721::get_component(contract).balanceOf(:account)
    }

    fn ownerOf(self: @ComponentState<TContractState>, tokenId: u256) -> starknet::ContractAddress {
      let contract = self.get_contract();
      ERC721::get_component(contract).ownerOf(:tokenId)
    }
  }
}
