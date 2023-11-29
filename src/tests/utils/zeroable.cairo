use zeroable::Zeroable;

// locals
use rewards::rewards::interface::{ RewardModel, RewardContent, RewardNote };
use super::partial_eq::{ RewardModelEq, RewardContentEq, RewardNoteEq };

impl RewardModelZeroable of Zeroable<RewardModel> {
  fn zero() -> RewardModel {
    RewardModel {
      name: 0,
      image_hash: 0,
      price: 0,
    }
  }

  #[inline(always)]
  fn is_zero(self: RewardModel) -> bool {
    self == RewardModelZeroable::zero()
  }

  #[inline(always)]
  fn is_non_zero(self: RewardModel) -> bool {
    self != RewardModelZeroable::zero()
  }
}

impl RewardContentZeroable of Zeroable<RewardContent> {
  fn zero() -> RewardContent {
    RewardContent {
      giver: starknet::contract_address_const::<0>(),
      note: RewardNoteZeroable::zero(),
    }
  }

  #[inline(always)]
  fn is_zero(self: RewardContent) -> bool {
    self == RewardContentZeroable::zero()
  }

  #[inline(always)]
  fn is_non_zero(self: RewardContent) -> bool {
    self != RewardContentZeroable::zero()
  }
}

impl RewardNoteZeroable of Zeroable<RewardNote> {
  fn zero() -> RewardNote {
    RewardNote {
      s1: 0,
      s2: 0,
    }
  }

  #[inline(always)]
  fn is_zero(self: RewardNote) -> bool {
    self == RewardNoteZeroable::zero()
  }

  #[inline(always)]
  fn is_non_zero(self: RewardNote) -> bool {
    self != RewardNoteZeroable::zero()
  }
}
