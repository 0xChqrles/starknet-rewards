use traits::Into;
use box::BoxTrait;
use messages::typed_data::Message;

// locals
use rewards::rewards::interface::{ Reward, RewardContent, RewardNote };

// sn_keccak('Reward(rewardModelId:u128,rewardContent:RewardContent)RewardContent(giver:felt252,note:RewardNote)RewardNote(s1:felt252,s2:felt252)')
const REWARD_TYPE_HASH: felt252 = 0x62ef8571f40b4f272324577f6c01e3f75b7bd39b8c2876f650e3fe7db7c345;

// sn_keccak('RewardContent(giver:felt252,note:RewardNote)RewardNote(s1:felt252,s2:felt252)')
const REWARD_CONTENT_TYPE_HASH: felt252 = 0x298734ad87b879f2809f5435b2b5add61714ba40a18a1d51a4f6fd3c13ef28e;

// sn_keccak('RewardNote(s1:felt252,s2:felt252)')
const REWARD_NOTE_TYPE_HASH: felt252 = 0x15ea0a942fb9e6382ec78db75f23d61278e286510db50f8b46777eb013d9281;

impl RewardMessage of Message<Reward> {
  #[inline(always)]
  fn compute_hash(self: @Reward) -> felt252 {
    let mut hash = pedersen::pedersen(0, REWARD_TYPE_HASH);

    hash = pedersen::pedersen(hash, (*self).reward_model_id.into());
    hash = pedersen::pedersen(hash, hash_reward_content(*self.reward_content));

    pedersen::pedersen(hash, 3)
  }
}

fn hash_reward_content(reward_content: RewardContent) -> felt252 {
  let mut hash = pedersen::pedersen(0, REWARD_CONTENT_TYPE_HASH);

  hash = pedersen::pedersen(hash, reward_content.giver.into());
  hash = pedersen::pedersen(hash, hash_reward_note(reward_content.note));

  pedersen::pedersen(hash, 3)
}

fn hash_reward_note(reward_note: RewardNote) -> felt252 {
  let mut hash = pedersen::pedersen(0, REWARD_NOTE_TYPE_HASH);

  hash = pedersen::pedersen(hash, reward_note.s1);
  hash = pedersen::pedersen(hash, reward_note.s2);

  pedersen::pedersen(hash, 3)
}
