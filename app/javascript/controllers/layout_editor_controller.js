import { Controller } from 'stimulus'

import Canvas from '../canvas/canvas'

export default class extends Controller {
  get buttons_data () { return this.canvas.buttons_data }

  connect () {
    this.canvas = new Canvas(window.gon.layout, window.gon.button_defaults)

    window.layout_editor_controller = this
  }

  updateButtons (buttons_data) {
    this.canvas.updateButtons(buttons_data)
  }

  removeButtons () {
    this.canvas.removeSelectedButtons()
  }

  unselectButtons () {
    this.canvas.unselectAllButtons()
    window.button_editor_controller.clear()
  }

  generateCode () {
    window.code_editor_controller.append(this.canvas.generateCode())
    window.canvas_controller.toggleCodeEditor()
  }

  exportSVG () {
    return this.canvas.exportSVG()
  }
}
