#[starknet::interface]
trait IERC721Soulbound<TState> {
  fn balance_of(self: @TState, account: starknet::ContractAddress) -> u256;
  fn owner_of(self: @TState, token_id: u256) -> starknet::ContractAddress;
}

#[starknet::interface]
trait IERC721SoulboundCamelOnly<TState> {
  fn balanceOf(self: @TState, account: starknet::ContractAddress) -> u256;
  fn ownerOf(self: @TState, tokenId: u256) -> starknet::ContractAddress;
}
