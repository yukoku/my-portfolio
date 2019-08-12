class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :creator, class_name: "User", optional: true
  belongs_to :ticket_attribute, optional: true
  belongs_to :ticket_status, optional: true
  belongs_to :ticket_priority, optional: true
  has_many_attached :attached_files
  validates_date :due_on, on_or_after: lambda { Time.zone.today }, allow_blank: true
  validate :validate_file_size
  validate :validate_file_count

private
  def validate_file_size
    return unless attached_files.attached?
    attached_files.each do |file|
      if file.blob.byte_size > 512.kilobytes
        file.purge
        errors.add(:file, I18n.t("errors.messages.file_too_large", file_size: "512Kbyte"))
      end
    end
  end

  def validate_file_count
    return unless attached_files.attached?
    if attached_files.count > 10
      attached_files[10..-1].map(&:purge)
      errors.add(:file, I18n.t("errors.messages.file_too_many", file_count: 10))
    end
  end
end
