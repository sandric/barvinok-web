import ace from 'brace'
import 'brace/mode/javascript'
import 'brace/theme/clouds'

export default class Editor {
  constructor (code) {
    if (this.isPlausible()) this.initialize(code)
  }

  isPlausible () {
    return !(document.getElementById('code-editor') === undefined)
  }

  initialize (code) {
    this.editor = ace.edit('code-editor')

    this.editor.setOptions({
      mode: 'ace/mode/javascript',
      theme: 'ace/theme/clouds',
      minLines: 26,
      maxLines: 26,
      fontSize: '16px',
      wrap: true,
      useSoftTabs: true,
      tabSize: 2
    })

    this.insert(code)

    this.editor.renderer.$blockCursor = true
  }

  insert (code, newline = false) {
    this.editor.session.insert({
      row: this.editor.session.getLength(),
      column: 0
    }, (newline ? '\n' : '') + code)
  }

  append (code) {
    this.insert(code, true)
  }

  clear () {
    this.editor.setValue('')
  }

  get code () {
    return this.editor.getValue()
  }

  get selected_code () {
    return this.editor.getSelectedText()
  }
}
