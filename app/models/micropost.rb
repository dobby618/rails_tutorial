class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,
            content_type: {
              in: %w[image/jpeg image/gif image/png],
              message: 'must be a valid image format'
            },
            size: { less_than: 5.megabytes, message: 'should be less than 5MB' }

  # 表示用のリサイズ済み画像を返す
  def display_image
    # variantによるリサイズは、リスト 13.71でこのメソッドが最初に呼ばれるときにオンデマンドで実行され、以後は結果をキャッシュしますので効率が高まります
    image.variant(resize_to_limit: [500, 500])
  end
end
