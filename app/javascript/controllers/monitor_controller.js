import { Controller } from 'stimulus'

import Monitor from '../monitor/monitor'

export default class extends Controller {
  static targets = [ 'displayAllButton', 'displayWarningsButton', 'displayErrorsButton' ]

  connect () {
    this.monitor = new Monitor()

    this.monitor.appendMessage('Test message 1')
    this.monitor.appendMessage('Test message 2')
    this.monitor.appendMessage('Test message 3')
    this.monitor.appendMessage('Test message 4')
    this.monitor.appendMessage('Test message 5')
    this.monitor.appendMessage('Test message 1')
    this.monitor.appendMessage('Test message 2')
    this.monitor.appendMessage('Test message 3')
    this.monitor.appendMessage('Test message 4')
    this.monitor.appendMessage('Test message 5')

    window.monitor_controller = this
  }

  clear () {
    this.monitor.clear()
  }

  displayAll () {
    this.displayAllButtonTarget.classList.add('is-info')
    this.displayWarningsButtonTarget.classList.remove('is-warning')
    this.displayErrorsButtonTarget.classList.remove('is-danger')

    this.monitor.display('all')
  }

  displayWarnings () {
    this.displayAllButtonTarget.classList.remove('is-info')
    this.displayWarningsButtonTarget.classList.add('is-warning')
    this.displayErrorsButtonTarget.classList.remove('is-danger')

    this.monitor.display('warnings')
  }

  displayErrors () {
    this.displayAllButtonTarget.classList.remove('is-info')
    this.displayWarningsButtonTarget.classList.remove('is-warning')
    this.displayErrorsButtonTarget.classList.add('is-danger')

    this.monitor.display('errors')
  }
}
