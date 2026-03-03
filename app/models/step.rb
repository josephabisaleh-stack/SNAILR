class Step < ApplicationRecord
  belongs_to :objective

  validates :done, inclusion: { in: [false, true] }
  validates :position, numericality: { greater_than_or_equal_to: 1 }

  def mark_step_as_done
    self.done = true
  end
end
