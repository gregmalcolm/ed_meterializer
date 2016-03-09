class Star < ActiveRecord::Base
  has_paper_trail
  
  before_validation :set_creator

  scope :by_system,     ->(system)  { where("UPPER(TRIM(system))=?", system.to_s.upcase.strip ) if system }
  scope :by_star,       ->(star)    { where("COALESCE(UPPER(TRIM(star)),'')=?", star.to_s.upcase.strip ) if star }
  scope :by_updater,    ->(updater) { where("UPPER(TRIM(updater))=?", updater.to_s.upcase.strip ) if updater }

  scope :not_me, ->(id) { where.not(id: id) if id }

  scope :updated_before, ->(time) { where("updated_at<?", time ) if Time.parse(time) rescue false }
  scope :updated_after,  ->(time) { where("updated_at>?", time ) if Time.parse(time) rescue false }

  validates :updater, :system, presence: true
  validate :key_fields_must_be_unique

  def creator
    updaters.first if updaters
  end

  private

  def set_creator
    self.updaters = [updater] if updater
  end

  def key_fields_must_be_unique
    if Star.by_system(self.system)
           .by_star(self.star)
           .not_me(self.id)
           .any?
      errors.add(:star, "has already been taken for this system")
    end
  end
end

