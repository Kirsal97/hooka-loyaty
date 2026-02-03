import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input", "form"]
  static values = { debounce: { type: Number, default: 300 } }

  connect() {
    this.timeout = null
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout)
  }

  search() {
    if (this.timeout) clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, this.debounceValue)
  }

  // Submit immediately on Enter key
  submitNow(event) {
    if (event.key === "Enter") {
      if (this.timeout) clearTimeout(this.timeout)
      this.formTarget.requestSubmit()
    }
  }
}
