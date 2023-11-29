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
use rewards::rewards::interface::{ RewardModel, RewardContent, RewardNote };

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
        note: StoreRewardNote::read_at_offset(:address_domain, :base, offset: offset + 1)?,
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
    StoreRewardNote::write_at_offset(:address_domain, :base, offset: offset + 1, value: value.note)
  }

  fn size() -> u8 {
    3
  }
}

// Reward Message

impl StoreRewardNote of Store::<RewardNote> {
  fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult::<RewardNote> {
    StoreRewardNote::read_at_offset(:address_domain, :base, offset: 0)
  }

  fn write(address_domain: u32, base: StorageBaseAddress, value: RewardNote) -> SyscallResult::<()> {
    StoreRewardNote::write_at_offset(:address_domain, :base, offset: 0, :value)
  }

  fn read_at_offset(address_domain: u32, base: StorageBaseAddress, offset: u8) -> SyscallResult<RewardNote> {
    Result::Ok(
      RewardNote {
        s1: storage_read_syscall(address_domain, storage_address_from_base_and_offset(base, offset))?,
        s2: storage_read_syscall(address_domain, storage_address_from_base_and_offset(base, offset + 1))?,
      }
    )
  }

  fn write_at_offset(
    address_domain: u32,
    base: StorageBaseAddress,
    offset: u8,
    value: RewardNote
  ) -> SyscallResult::<()> {
    // name
    storage_write_syscall(address_domain, storage_address_from_base_and_offset(base, offset), value.s1)?;
    storage_write_syscall(address_domain, storage_address_from_base_and_offset(base, offset + 1), value.s2)
  }

  fn size() -> u8 {
    2
  }
}
