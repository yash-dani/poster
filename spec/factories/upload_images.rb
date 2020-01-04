# == Schema Information
#
# Table name: upload_images
#
#  id          :bigint           not null, primary key
#  figure_type :string
#  height      :integer
#  image_data  :text
#  index       :string
#  width       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  upload_id   :integer
#
# Indexes
#
#  index_upload_images_on_upload_id  (upload_id)
#

FactoryBot.define do
  factory :upload_image do
    
  end
end
