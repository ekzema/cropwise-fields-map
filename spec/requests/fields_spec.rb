require 'rails_helper'

RSpec.describe FieldsController, type: :controller do
  let(:factory) { RGeo::Geos.factory(srid: 4326) }
  let(:polygon) do
    factory.polygon(
      factory.linear_ring([
                            factory.point(30.0, 50.0),
                            factory.point(31.0, 50.0),
                            factory.point(31.0, 51.0),
                            factory.point(30.0, 50.0)
                          ])
    )
  end

  let(:valid_attributes) do
    {
      name: "Some Field for test",
      geojson_shape: {
        type: "Feature",
        properties: {},
        geometry: {
          type: "Polygon",
          coordinates: [
            [
              [ 30.0, 50.0 ],
              [ 31.0, 50.0 ],
              [ 31.0, 51.0 ],
              [ 30.0, 50.0 ]
            ]
          ]
        }
      }.to_json
    }
  end

  let(:invalid_attributes) do
    { name: "" }
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    let!(:field) { Field.create!(name: "Test", shape: polygon) }

    it "returns a success response" do
      get :show, params: { id: field.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    let!(:field) { Field.create!(name: "Test", shape: polygon) }

    it "returns a success response" do
      get :edit, params: { id: field.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Field" do
        expect {
          post :create, params: { field: valid_attributes }
        }.to change(Field, :count).by(1)
      end

      it "redirects to the created field" do
        post :create, params: { field: valid_attributes }
        expect(response).to redirect_to(Field.last)
      end
    end

    context "with invalid params" do
      it "does not create a new Field" do
        expect {
          post :create, params: { field: invalid_attributes }
        }.not_to change(Field, :count)
      end

      it "renders the new template" do
        post :create, params: { field: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    let!(:field) { Field.create!(name: "Test", shape: polygon) }

    context "with valid params" do
      it "updates the requested field" do
        patch :update, params: { id: field.id, field: { name: "Updated" } }
        field.reload
        expect(field.name).to eq("Updated")
      end

      it "redirects to the field" do
        patch :update, params: { id: field.id, field: { name: "Updated" } }
        expect(response).to redirect_to(field)
      end
    end

    context "with invalid params" do
      it "renders the edit template" do
        patch :update, params: { id: field.id, field: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:field) { Field.create!(name: "Test", shape: polygon) }

    it "destroys the requested field" do
      expect {
        delete :destroy, params: { id: field.id }
      }.to change(Field, :count).by(-1)
    end

    it "redirects to the fields list" do
      delete :destroy, params: { id: field.id }
      expect(response).to redirect_to(fields_url)
    end
  end
end
