class Phrase < ActiveRecord::Base
  MAX_PHRASES = 3
  MAX_PHRASE_LENGTH = 60

  belongs_to :cooper

  validates_presence_of :cooper_id
  validates_presence_of :text
  validates_length_of   :text, { maximum: MAX_PHRASE_LENGTH }

  validate  :can_only_have_three

  def can_only_have_three
    unless cooper.phrases.all.count < MAX_PHRASES
      errors.add(:too_many, "You can only add up to #{MAX_PHRASES} phrases")
    end
  end
end
