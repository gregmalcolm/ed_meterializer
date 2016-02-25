class StarSerializer < ActiveModel::Serializer
  attributes :id,
             :system,
             :updater,
             :star,
             :spectral_class,
             :spectral_subclass,
             :solar_mass,
             :solar_radius,
             :surface_temp,
             :star_age,
             :orbit_period,
             :arrival_point,
             :luminosity,
             :notes,
             :image_url,
             :updated_at,
             :created_at
end
