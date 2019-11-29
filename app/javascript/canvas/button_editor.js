import * as d3 from 'd3'

export default class ButtonEditor {
  static get empty_defaults () {
    return {
      title: '',
      subtitle: '',
      title_color: '#000000',
      subtitle_color: '#000000',
      background_color: '#FFFFFF'
    }
  }
  
  get title_element () { return d3.select(document.querySelector('#button-editor-preview .title')) }
  get subtitle_element () { return d3.select(document.querySelector('#button-editor-preview .subtitle')) }
  get inner_button_element () { return d3.select(('#button-editor-preview .inner-button')) }

  get values () { return this._values }
  set values (values) { this._values = values; this.updateButton() }

  constructor (defaults) {
    if (this.isPlausible()) this.initialize(defaults)
  }

  isPlausible () {
    return !(document.getElementById('layout-editor') === undefined)
  }

  initialize (defaults) {
    this.defaults = defaults || ButtonEditor.empty_defaults
    this.values = this.defaults
  }

  updateButton () {
    this.title_element
      .text(this.values.title)
      .attr('fill', this.values.title_color)
    this.subtitle_element
      .text(this.values.subtitle)
      .attr('fill', this.values.subtitle_color)

    this.inner_button_element.attr('fill', this.values.background_color)
  }

  clear () {
    this.values = this.defaults
  }

  saveDefaults () {
    this.defaults = this.values
  }
}
