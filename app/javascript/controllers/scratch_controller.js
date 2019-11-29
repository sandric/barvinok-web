import { Controller } from 'stimulus'

import Editor from '../editor/editor'

export default class extends Controller {
  get code () {
    return (this.editor.selected_code.length > 0 ? this.editor.selected_code : this.editor.code)
  }

  get terminal () {
    return document.querySelector('#scratch-console iframe').contentWindow.terminal
  }

  connect () {
    this.editor = new Editor()

    window.scratch_controller = this
  }

  eval () {
    this.terminal.write(this.code)
  }

  clear () {
    this.editor.clear()
  }
}
