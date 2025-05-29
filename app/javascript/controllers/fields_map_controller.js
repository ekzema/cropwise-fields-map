import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

export default class extends Controller {
  connect() {
    const geojsonCollection = this.element.dataset.geojsonCollection

    let features = []
    if (geojsonCollection) {
      try {
        features = JSON.parse(geojsonCollection)
      } catch (e) {
        console.error("Invalid GeoJSON collection:", e)
      }
    }

    const mapContainer = this.element.querySelector("#fields-map")
    if (!mapContainer) return

    const map = L.map(mapContainer)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors"
    }).addTo(map)

    if (Array.isArray(features) && features.length > 0) {
      const layers = features.map(feature => L.geoJSON(feature).addTo(map))
      const allBounds = layers
        .map(layer => layer.getBounds())
        .filter(bounds => bounds.isValid())

      if (allBounds.length > 0) {
        const groupBounds = allBounds.reduce((acc, bounds) => acc.extend(bounds))
        map.fitBounds(groupBounds)
        return
      }
    }

    map.setView([50.45, 30.52], 5)
  }
}
