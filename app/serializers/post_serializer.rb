# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  abstract     :text
#  authors      :text
#  body         :json
#  deleted_at   :datetime
#  imprint_date :string
#  imprint_type :string
#  plugins      :jsonb            not null
#  publish_date :datetime
#  published_at :datetime
#  publisher    :string
#  slug         :string
#  title        :text
#  visibility   :integer          default("public"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_posts_on_slug     (slug) UNIQUE
#  index_posts_on_user_id  (user_id)
#

class PostSerializer
  include FastJsonapi::ObjectSerializer
  include Rails.application.routes.url_helpers

  has_many :uploads
	has_many :citations
  has_many :figures

  attributes :title, :authors, :publisher, :id,
    :created_at, :updated_at, :plugins, :slug

  attribute :form_url do |object|
    object.id.present? ? "/posts/#{object.slug}" : "/posts"
  end

  attribute :body do |object|
    if object.body
      object.body
        .gsub("<__content__>", "<br/>")
        .gsub("</__content__>", "")
    end
  end

  attribute :cable_url do |object|
    Rails.env.development? ? "ws://localhost:3000/cable" : "wss://#{ENV["HOSTNAME"]}/cable"
  end

  attribute :upload_url do |object|
    object.uploads.first.file_url if object.uploads.any?
  end

  attribute :tags do |object|
    # object.tags.to_json
    object.tags.order(updated_at: :desc).map{|tag|
    {
      id: tag.id.to_s,
      text: tag.text,
      slug: tag.slug,
      }
    }.as_json
  end

end
