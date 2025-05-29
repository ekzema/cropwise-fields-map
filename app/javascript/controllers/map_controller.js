import { Controller } from "@hotwired/stimulus"
import L from "leaflet"
import "leaflet-draw"

export default class extends Controller {
  static targets = ["map", "input", "submitButton"]

  connect() {
    this.map = L.map(this.mapTarget).setView([50.45, 30.52], 13)
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors"
    }).addTo(this.map)

    this.drawnItems = new L.FeatureGroup()
    this.map.addLayer(this.drawnItems)

    const drawControl = new L.Control.Draw({
      draw: {
        polygon: true,
        polyline: false,
        rectangle: false,
        circle: false,
        marker: false,
        circlemarker: false
      },
      edit: {
        featureGroup: this.drawnItems,
        remove: true
      }
    })

    this.map.addControl(drawControl)

    this.map.on(L.Draw.Event.CREATED, (e) => {
      this.drawnItems.clearLayers()
      this.drawnItems.addLayer(e.layer)
      this.updateInput()
      this.toggleSubmitButton(true)
    })

    this.map.on("draw:edited", () => this.updateInput())

    this.map.on("draw:deleted", () => {
      this.updateInput()
      this.toggleSubmitButton(false)
    })

    this.map.on("draw:editstart", () => {
      this.toggleSubmitButton(false)
    })

    this.map.on("draw:editstop", () => {
      const hasPolygon = this.drawnItems.getLayers().length > 0
      this.toggleSubmitButton(hasPolygon)
    })

    const existingGeoJson = this.inputTarget.value
    if (existingGeoJson) {
      const layer = L.geoJSON(JSON.parse(existingGeoJson))
      layer.eachLayer(l => this.drawnItems.addLayer(l))
      this.map.fitBounds(layer.getBounds())
      this.toggleSubmitButton(true)
    }
  }

  toggleSubmitButton(enabled) {
    this.submitButtonTarget.disabled = !enabled
  }

  updateInput() {
    const geojson = this.drawnItems.toGeoJSON()
    this.inputTarget.value = JSON.stringify(geojson.features[0]?.geometry || null)
  }
}
