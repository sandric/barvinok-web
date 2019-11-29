export default class Monitor {
  get monitor () {
    return document.querySelector('#monitor')
  }

  constructor () {
    if (this.isPlausible()) this.initialize()
  }

  isPlausible () {
    return !(this.monitor === undefined)
  }

  initialize () {
  }

  formatMessage (message) {
    return `<p class="monitor-message">${message}</p>`
  }

  appendMessage (message) {
    this.monitor.innerHTML += this.formatMessage(message)
  }

  clear () {
    this.monitor.innerHTML = ''
  }

  display (type) {
    console.log('displaying only: ' + type)
  }
}
