import { Controller } from "stimulus"
import ColorPicker from '../color_picker/color_picker.js'

import ButtonEditor from '../canvas/button_editor'

export default class extends Controller {
  static targets = ['buttonEditorAngle', 'buttonEditorTitle', 'buttonEditorSubtitle']

  get button_defaults () { return this.button_editor.defaults }

  connect () {
    this.button_editor = new ButtonEditor(window.gon.button_defaults)
    this.initializeColorPickers()
    this.ignoreButtonFieldsChanges = false
    this.updateButtonEditorFields()

    window.button_editor_controller = this
  }

  setValues (values) {
    this.button_editor.values = values
    this.updateButtonEditorFields()
  }

  getButtonEditorValues () {
    return {
      angle: this.buttonEditorAngleTarget.value,
      title: this.buttonEditorTitleTarget.value,
      subtitle: this.buttonEditorSubtitleTarget.value,
      title_color: this.buttonEditorTitleColorPickerTarget.getColor(),
      subtitle_color: this.buttonEditorSubtitleColorPickerTarget.getColor(),
      background_color: this.buttonEditorBackgroundColorPickerTarget.getColor()
    }
  }

  updateButtonEditorFields () {
    this.ignoreButtonFieldsChanges = true

    this.buttonEditorAngleTarget.value = this.button_editor.values.angle
    this.buttonEditorTitleTarget.value = this.button_editor.values.title
    this.buttonEditorSubtitleTarget.value = this.button_editor.values.subtitle
    this.buttonEditorTitleColorPickerTarget.setColor(this.button_editor.values.title_color)
    this.buttonEditorSubtitleColorPickerTarget.setColor(this.button_editor.values.subtitle_color)
    this.buttonEditorBackgroundColorPickerTarget.setColor(this.button_editor.values.background_color)

    this.ignoreButtonFieldsChanges = false
  }

  initializeColorPickers () {
    const selectors = ['title-color', 'subtitle-color', 'background-color']

    selectors.forEach((selector) => {
      const target = ('button-editor-' + selector + '-picker-target').replace(/-([a-z])/g, (g) => { return g[1].toUpperCase() })
      this[target] = new ColorPicker(`#button-editor-${selector}`,
                                     {
                                       save: (_, __) => {
                                         this.buttonEditorChanged()
                                       }
                                     })
    })
  }

  buttonEditorChanged () {
    if (!this.ignoreButtonFieldsChanges) {
      this.button_editor.values = this.getButtonEditorValues()
    }
  }

  clear () {
    this.button_editor.clear()
    this.updateButtonEditorFields()
  }

  buttonEditorSaveDefaults () {
    this.button_editor.saveDefaults()
  }

  buttonEditorApply () {
    window.layout_editor_controller.updateButtons(this.button_editor.values)
  }
}
