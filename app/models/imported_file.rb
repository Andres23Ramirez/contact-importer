class ImportedFile < ApplicationRecord
  belongs_to :user
  enum status: { on_hold: 0, processing: 1, failed: 2, finished: 3 }

  before_create :set_default_status

  private

  def set_default_status
    self.status ||= :on_hold
  end
end
