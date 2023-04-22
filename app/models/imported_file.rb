class ImportedFile < ApplicationRecord
  belongs_to :user
  enum status: { on_hold: 0, processing: 1, failed: 2, finished: 3 }
end
