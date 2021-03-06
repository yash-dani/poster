# == Schema Information
#
# Table name: tag_ownerships
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer
#  tag_id     :integer
#

class TagOwnership < ApplicationRecord
  belongs_to :post
  belongs_to :tag, counter_cache: :posts_count
end
