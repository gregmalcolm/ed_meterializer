class WorldTreeSerializer < WorldSerializer
  has_one :world_survey
  has_many :basecamps
  has_many :site_surveys
end