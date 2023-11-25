use array::{ ArrayTrait, SpanTrait };
use traits::{ Into, TryInto };
use option::OptionTrait;
use integer::Storeu256;
use starknet::{
  Store,
  storage_address_from_base_and_offset,
  storage_read_syscall,
  storage_write_syscall,
  SyscallResult,
  StorageBaseAddress,
  Felt252TryIntoContractAddress
};

// locals
use rewards::rewards::interface::{ RewardModel, RewardContent, RewardMessage };

// Reward Model

impl StoreRewardModel of Store::<RewardModel> {
  fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult::<RewardModel> {
    StoreRewardModel::read_at_offset(:address_domain, :base, offset: 0)
  }

  fn write(address_domain: u32, base: StorageBaseAddress, value: RewardModel) -> SyscallResult::<()> {
    StoreRewardModel::write_at_offset(:address_domain, :base, offset: 0, :value)
  }

  fn read_at_offset(address_domain: u32, base: StorageBaseAddress, offset: u8) -> SyscallResult<RewardModel> {
    Result::Ok(
      RewardModel {
        name: storage_read_syscall(address_domain, storage_address_from_base_and_offset(base, offset))?,
        image_hash: Storeu256::read_at_offset(:address_domain, :base, offset: offset + 1)?,
        price: Storeu256::read_at_offset(:address_domain, :base, offset: offset + 3)?,
      }
    )
  }

  fn write_at_offset(
    address_domain: u32,
    base: StorageBaseAddress,
    offset: u8,
    value: RewardModel
  ) -> SyscallResult::<()> {
    // name
    storage_write_syscall(address_domain, storage_address_from_base_and_offset(base, offset), value.name)?;

    // image hash
    Storeu256::write_at_offset(:address_domain, :base, offset: offset + 1, value: value.image_hash)?;

    // price
    Storeu256::write_at_offset(:address_domain, :base, offset: offset + 3, value: value.price)
  }

  fn size() -> u8 {
    5
  }
}

// Reward Content

impl StoreRewardContent of Store::<RewardContent> {
  fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult::<RewardContent> {
    StoreRewardContent::read_at_offset(:address_domain, :base, offset: 0)
  }

  fn write(address_domain: u32, base: StorageBaseAddress, value: RewardContent) -> SyscallResult::<()> {
    StoreRewardContent::write_at_offset(:address_domain, :base, offset: 0, :value)
  }

  fn read_at_offset(address_domain: u32, base: StorageBaseAddress, offset: u8) -> SyscallResult<RewardContent> {
    Result::Ok(
      RewardContent {
        giver: storage_read_syscall(address_domain, storage_address_from_base_and_offset(base, offset))?
          .try_into()
          .unwrap(),
        message: StoreRewardMessage::read_at_offset(:address_domain, :base, offset: offset + 1)?,
      }
    )
  }

  fn write_at_offset(
    address_domain: u32,
    base: StorageBaseAddress,
    offset: u8,
    value: RewardContent
  ) -> SyscallResult::<()> {
    // giver
    storage_write_syscall(address_domain, storage_address_from_base_and_offset(base, offset), value.giver.into())?;

    // message
    StoreRewardMessage::write_at_offset(:address_domain, :base, offset: offset + 1, value: value.message)
  }

  fn size() -> u8 {
    3
  }
}

// Reward Message

impl StoreRewardMessage of Store::<RewardMessage> {
  fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult::<RewardMessage> {
    StoreRewardMessage::read_at_offset(:address_domain, :base, offset: 0)
  }

  fn write(address_domain: u32, base: StorageBaseAddress, value: RewardMessage) -> SyscallResult::<()> {
    StoreRewardMessage::write_at_offset(:address_domain, :base, offset: 0, :value)
  }

  fn read_at_offset(address_domain: u32, base: StorageBaseAddress, offset: u8) -> SyscallResult<RewardMessage> {
    Result::Ok(
      RewardMessage {
        s1: storage_read_syscall(address_domain, storage_address_from_base_and_offset(base, offset))?,
        s2: storage_read_syscall(address_domain, storage_address_from_base_and_offset(base, offset + 1))?,
      }
    )
  }

  fn write_at_offset(
    address_domain: u32,
    base: StorageBaseAddress,
    offset: u8,
    value: RewardMessage
  ) -> SyscallResult::<()> {
    // name
    storage_write_syscall(address_domain, storage_address_from_base_and_offset(base, offset), value.s1)?;
    storage_write_syscall(address_domain, storage_address_from_base_and_offset(base, offset), value.s2)
  }

  fn size() -> u8 {
    2
  }
}
