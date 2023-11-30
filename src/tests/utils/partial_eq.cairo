use traits::PartialEq;

// locals
use rewards::rewards::interface::{ RewardContent, RewardNote, RewardModel };

// We avoid using to many bitwise operators
impl RewardContentEq of PartialEq<RewardContent> {
  fn eq(lhs: @RewardContent, rhs: @RewardContent) -> bool {
    if (*lhs.dispatcher != *rhs.dispatcher) {
      false
    } else if (*lhs.note != *rhs.note) {
      false
    } else {
      true
    }
  }

  #[inline(always)]
  fn ne(lhs: @RewardContent, rhs: @RewardContent) -> bool {
    !(lhs == rhs)
  }
}

impl RewardNoteEq of PartialEq<RewardNote> {
  fn eq(lhs: @RewardNote, rhs: @RewardNote) -> bool {
    if (*lhs.s1 != *rhs.s1) {
      false
    } else if (*lhs.s2 != *rhs.s2) {
      false
    } else {
      true
    }
  }

  #[inline(always)]
  fn ne(lhs: @RewardNote, rhs: @RewardNote) -> bool {
    !(lhs == rhs)
  }
}

impl RewardModelEq of PartialEq<RewardModel> {
  fn eq(lhs: @RewardModel, rhs: @RewardModel) -> bool {
    if (*lhs.image_hash != *rhs.image_hash) {
      false
    } else if (*lhs.name != *rhs.name) {
      false
    } else {
      true
    }
  }

  #[inline(always)]
  fn ne(lhs: @RewardModel, rhs: @RewardModel) -> bool {
    !(lhs == rhs)
  }
}
