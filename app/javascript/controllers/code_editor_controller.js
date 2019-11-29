import { Controller } from 'stimulus'

import Editor from '../editor/editor'

export default class extends Controller {
  get code () { return this.editor.code }

  connect () {
    this.editor = new Editor(window.gon.code)

    window.code_editor_controller = this
  }

  append (code) {
    this.editor.append(code)
  }
}
