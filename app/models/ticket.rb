class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :creator, class_name: "User", optional: true
  has_many_attached :attached_files
  has_many :comments, dependent: :destroy
  has_many :ticket_metadata_values, dependent: :destroy, inverse_of: :ticket
  accepts_nested_attributes_for :ticket_metadata_values, allow_destroy: true
  validates_date :due_on, on_or_after: lambda { Time.zone.today }, allow_blank: true
  validate :validate_file_size
  validate :validate_file_count

  # ransack 4 以降は検索可能な属性・関連を明示する必要がある
  def self.ransackable_attributes(_auth_object = nil)
    %w[title description due_on]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

private

  def validate_file_size
    return unless attached_files.attached?
    attached_files.each do |file|
      if file.blob.byte_size > 512.kilobytes
        errors.add(:file, I18n.t("errors.messages.file_too_large", file_size: "512Kbyte"))
      end
    end
  end

  def validate_file_count
    return unless attached_files.attached?
    if attached_files.count > 10
      errors.add(:file, I18n.t("errors.messages.file_too_many", file_count: 10))
    end
  end
end
