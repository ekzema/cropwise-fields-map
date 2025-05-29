import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

export default class extends Controller {
  connect() {
    const geojson = this.element.dataset.geojson
    if (!geojson) return

    const mapContainer = this.element.querySelector("#readonly-map")
    if (!mapContainer) return

    const map = L.map(mapContainer)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "© OpenStreetMap contributors"
    }).addTo(map)

    const layer = L.geoJSON(JSON.parse(geojson)).addTo(map)

    map.fitBounds(layer.getBounds())
  }
}
