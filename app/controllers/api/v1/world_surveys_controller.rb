module Api
  module V1
    class WorldSurveysController < ApplicationController
      before_action :authorize_admin!, except: [:index, :show]
      before_action :set_world_survey, only: [:show, :update, :destroy]

      def index
        @world_surveys = filtered.page(page).
                                  per(per_page).
                                  order("updated_at")
        render json: @world_surveys, serializer: PaginatedSerializer,
                                     each_serializer: ::V1::WorldSurveySerializer
      end

      def show
        render json: @world_survey, serializer: ::V1::WorldSurveySerializer
      end

      def create
        @world_survey = WorldSurvey.new(world_survey_params)

        if @world_survey.save
          render json: @world_survey, serializer: ::V1::WorldSurveySerializer,
                                      status: :created, 
                                      location: @world_survey
        else
          render json: @world_survey.errors, status: :unprocessable_entity
        end
      end

      def update
        @world_survey = WorldSurvey.find(params[:id])

        if @world_survey.update(world_survey_params)
          head :no_content
        else
          render json: @world_survey.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @world_survey.destroy

        head :no_content
      end

      private

      def set_world_survey
        @world_survey = WorldSurvey.find(params[:id])
      end

      def world_survey_params
        # Blacklisting isn't the most secure way of doing this
        # but the attribute list is long and the security implications
        # are low here
        params.require(:world_survey)
              .permit(:system,
                      :commander,
                      :world,
                      :world_type,
                      :terraformable,
                      :gravity,
                      :terrain_difficulty,
                      :arrival_point,
                      :atmosphere_type,
                      :vulcanism_type,
                      :radius,
                      :reserve,
                      :mass,
                      :surface_temp,
                      :surface_pressure,
                      :orbit_period,
                      :rotation_period,
                      :semi_major_axis,
                      :rock_pct,
                      :metal_pct,
                      :ice_pct,
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
                      :yttrium)
      end

      def filtered
        q = params[:q]
        if q.present?
          WorldSurvey.by_system(q[:system]).
                      by_commander(q[:commander]).
                      by_world(q[:world]).
                      updated_before(q[:updated_before]).
                      updated_after(q[:updated_after])
        else
          WorldSurvey.all
        end
      end
    end
  end
end
