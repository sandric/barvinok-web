import '@simonwep/pickr/dist/themes/nano.min.css'
import Pickr from '@simonwep/pickr'

export default class ColorPicker {
  settings (selector) {
    return {
      el: selector,
      theme: 'nano',
      default: 'fff',

      swatches: [
        'rgba(244, 67, 54, 1)',
        'rgba(233, 30, 99, 0.95)',
        'rgba(156, 39, 176, 0.9)',
        'rgba(103, 58, 183, 0.85)',
        'rgba(63, 81, 181, 0.8)',
        'rgba(33, 150, 243, 0.75)',
        'rgba(3, 169, 244, 0.7)',
        'rgba(0, 188, 212, 0.7)',
        'rgba(0, 150, 136, 0.75)',
        'rgba(76, 175, 80, 0.8)',
        'rgba(139, 195, 74, 0.85)',
        'rgba(205, 220, 57, 0.9)',
        'rgba(255, 235, 59, 0.95)',
        'rgba(255, 193, 7, 1)'
      ],

      components: {
        preview: true,
        opacity: true,
        hue: true,

        interaction: {
          hex: true,
          save: true
        }
      }
    }
  }

  constructor (selector, hooks) {
    this.picker = Pickr.create(this.settings(selector))

    if (hooks !== undefined && Object.keys(hooks).length > 0) {
      Object.keys(hooks).forEach((hook) => {
        this.picker.on(hook, hooks[hook])
      })
    }
  }

  getColor () {
    return this.picker.getColor().toHEXA().toString()
  }

  setColor (value) {
    return this.picker.setColor(value)
  }
}
