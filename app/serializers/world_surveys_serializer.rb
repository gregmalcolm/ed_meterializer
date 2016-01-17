class WorldSurveysSerializer < ActiveModel::Serializer
  attributes :system,
             :commander,
             :world,
             :world_type,
             :terraformable,
             :gravity,
             :arrival_point,
             :atmosphere_type,
             :vulcanism_type,
             :radius,
             :terrain_difficulty,
             :notes,
             :carbon,
             :iron,
             :nickel,
             :phosphorus,
             :sulphur,
             :arsenic,
             :chromium,
             :germanium,
             :manganese,
             :selenium,
             :vanadium,
             :zinc,
             :zirconium,
             :cadmium,
             :mercury,
             :molybdenum,
             :niobium,
             :tin,
             :tungsten,
             :antimony,
             :polonium,
             :ruthenium,
             :technetium,
             :tellurium,
             :yttrium
end
