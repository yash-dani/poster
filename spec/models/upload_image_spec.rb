# == Schema Information
#
# Table name: upload_figures
#
#  id          :bigint           not null, primary key
#  caption     :text
#  figure_type :string
#  height      :integer
#  image_data  :text
#  index       :string
#  name        :string
#  page        :integer
#  width       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  upload_id   :integer
#
# Indexes
#
#  index_upload_figures_on_upload_id  (upload_id)
#

require 'rails_helper'

RSpec.describe UploadImage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
