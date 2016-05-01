module Api
  module V4
    class SurveysController < ApplicationController
      include JSONAPI::ActsAsResourceController
      include DataDumpActions
      before_action :authorize_user!, except: [:index, :show, :download, :md5]
      
      before_action :set_survey, only: [:show, :update, :destroy]
      before_action :set_world, only: [:index, :show, :update, :destroy]
      
      before_action only: [:update] {
        unless error_flag_update?
          authorize_change!(@survey.commander,
                            jsonapi_attribute_params[:commander])
        end
      }
      before_action only: [:destroy] {
        authorize_change!(@survey.commander,
                          params[:user])
      }

      def index
        @surveys = filtered.page(page).
                                 per(per_page).
                                 order(ordering)
        render json: @surveys, serializer: PaginatedSerializer,
                               include: params[:include]
      end

      def show
        render json: @survey, include: params[:include]
      end

      def create
        @survey = Survey.new(new_survey_params)
        @survey[:surveyed_at] ||= Date.today

        if @survey.save
          render json: @survey, status: :created, 
                                location: @survey
        else
          render json: errors_as_jsonapi(@survey.errors), status: :unprocessable_entity
        end
      end

      def update
        @survey = Survey.find(params[:id])

        if @survey.update(edit_survey_params)
          head :no_content
        else
          render json: errors_as_jsonapi(@survey.errors), status: :unprocessable_entity
        end
      end

      def destroy
        @survey.destroy

        head :no_content
      end

      private

      def set_survey
        @survey = Survey.find(params[:id])
      end
      
      def set_world
        @world = if params[:world_id]
                   World.find(params[:world_id]) 
                 else
                   @survey.world if @survey
                 end
      end

      def survey_params
        sp = params.require(:data)
                   .require(:attributes)
                   .permit(:commander,
                           :resource, 
                           :surveyed_at,
                           :notes,
                           :image_url,
                           :error_flag,
                           :error_description,
                           :error_updater,
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
                           :yttrium,
                           surveyed_by: []
                          )
        sp = add_relationship_id(sp, :world)
        sp = add_relationship_id(sp, :basecamp)
        sp = add_relationship_id(sp, :system)
      end

      def new_survey_params
        {
          world_id: params[:world_id],
          commander: params[:commander]
        }.merge(survey_params)
      end
      
      def edit_survey_params
        sp = survey_params
        sp.delete(:commander)
        sp
      end

      def filtered
        Survey.by_world_id(params[:world_id])
              .by_basecamp_id(params[:basecamp_id])
              .by_resource(params[:resource])
              .by_commander(params[:commander])
              .updated_before(params[:updated_before])
              .updated_after(params[:updated_after])
      end
      
      def per_page
        params[:per_page] || 100
      end

      def error_flag_update?
        survey_params.keys.include?("error_flag") &&
          !survey_params.keys.detect { |survey| !(survey =~ /^error_/) }
      end
    end
  end
end
