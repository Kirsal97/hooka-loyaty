import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const bootstrap = window.bootstrap
    if (!bootstrap?.Toast) return

    this.element.querySelectorAll(".toast").forEach((toastElement) => {
      const toast = new bootstrap.Toast(toastElement)
      toast.show()
    })
  }
}
