use traits::Into;
use box::BoxTrait;
use messages::typed_data::Message;

// locals
use rewards::rewards::interface::{ RewardDispatch, Reward, RewardContent, RewardNote };

// sn_keccak('RewardDispatch(toDomain:felt252,reward:Reward)Reward(rewardModelId:felt252,rewardContent:RewardContent)RewardContent(dispatcher:felt252,note:RewardNote)RewardNote(s1:felt252,s2:felt252)')
const REWARD_DISPATCH_TYPE_HASH: felt252 = 0x21fd54b80673d5d26693d26385a1f07631d8d206503d8897cf05f4f18bdf4c3;

// sn_keccak('Reward(rewardModelId:felt252,rewardContent:RewardContent)RewardContent(dispatcher:felt252,note:RewardNote)RewardNote(s1:felt252,s2:felt252)')
const REWARD_TYPE_HASH: felt252 = 0x17caca0859b321839b202f5f1df62d10a37045a4a70010814ab23f0c17609e5;

// sn_keccak('RewardContent(dispatcher:felt252,note:RewardNote)RewardNote(s1:felt252,s2:felt252)')
const REWARD_CONTENT_TYPE_HASH: felt252 = 0x3aab5e561941a8f94824687eeee48ce119bc845a9d01e8b7e3eac0a7f4e6cf5;

// sn_keccak('RewardNote(s1:felt252,s2:felt252)')
const REWARD_NOTE_TYPE_HASH: felt252 = 0x15ea0a942fb9e6382ec78db75f23d61278e286510db50f8b46777eb013d9281;

impl RewardDispatchMessage of Message<RewardDispatch> {
  #[inline(always)]
  fn compute_hash(self: @RewardDispatch) -> felt252 {
    let mut hash = pedersen::pedersen(0, REWARD_DISPATCH_TYPE_HASH);

    hash = pedersen::pedersen(hash, *self.to_domain);
    hash = pedersen::pedersen(hash, hash_reward(*self.reward));

    pedersen::pedersen(hash, 3)
  }
}

fn hash_reward(reward: Reward) -> felt252 {
  let mut hash = pedersen::pedersen(0, REWARD_TYPE_HASH);

  hash = pedersen::pedersen(hash, reward.reward_model_id.into());
  hash = pedersen::pedersen(hash, hash_reward_content(reward.reward_content));

  pedersen::pedersen(hash, 3)
}

fn hash_reward_content(reward_content: RewardContent) -> felt252 {
  let mut hash = pedersen::pedersen(0, REWARD_CONTENT_TYPE_HASH);

  hash = pedersen::pedersen(hash, reward_content.dispatcher.into());
  hash = pedersen::pedersen(hash, hash_reward_note(reward_content.note));

  pedersen::pedersen(hash, 3)
}

fn hash_reward_note(reward_note: RewardNote) -> felt252 {
  let mut hash = pedersen::pedersen(0, REWARD_NOTE_TYPE_HASH);

  hash = pedersen::pedersen(hash, reward_note.s1);
  hash = pedersen::pedersen(hash, reward_note.s2);

  pedersen::pedersen(hash, 3)
}
