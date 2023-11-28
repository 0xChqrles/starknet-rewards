use zeroable::Zeroable;

// locals
use rewards::rewards::interface::RewardModel;
use super::partial_eq::RewardModelEq;

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
