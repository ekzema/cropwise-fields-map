class FieldsController < ApplicationController
  before_action :set_field, only: %i[show edit update destroy]

  def index
    @fields = Field.all
  end

  def show; end

  def new
    @field = Field.new
  end

  def edit; end

  def create
    @field = Field.new(name: field_params[:name])

    if field_params[:geojson_shape].present?
      @field.shape = prepare_shape(field_params[:geojson_shape])
    end

    if @field.save
      redirect_to @field, notice: "Field created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    @field.name = field_params[:name]

    if field_params[:geojson_shape].present?
      @field.shape = prepare_shape(field_params[:geojson_shape])
    end

    if @field.save
      redirect_to @field, notice: "Field updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @field.destroy
    redirect_to fields_url, notice: "Field removed"
  end

  private

  def set_field
    @field = Field.find(params[:id])
  end

  def field_params
    params.require(:field).permit(:name, :geojson_shape)
  end

  def prepare_shape(geojson_string)
    factory     = RGeo::Geos.factory(srid: 4326)
    parsed_json = JSON.parse(geojson_string)
    geometry    = parsed_json["type"] == "Feature" ? parsed_json["geometry"] : parsed_json
    if geometry["type"] == "MultiPolygon"
      geometry = {
        "type" => "Polygon",
        "coordinates" => geometry["coordinates"][0]
      }
    end

    geojson = RGeo::GeoJSON.decode({ type: "Feature", geometry: geometry }
                                     .to_json, json_parser: :json, geo_factory: factory)

    geojson&.geometry
  end
end
