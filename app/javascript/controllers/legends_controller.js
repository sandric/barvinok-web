import { Controller } from 'stimulus'
import Choices from 'choices.js'

import Legends from '../canvas/legends'

export default class extends Controller {
  static targets = [ 'displayAllButton', 'displayBackgroundButton', 'displayTitleButton', 'displaySubtitleButton' ]

  get selected_keyboard () {
    return document.querySelector('#keyboards-select').selectedOptions[0].value    
  }

  get selected_branch () {
    return document.querySelector('#branches-select').selectedOptions[0].value
  }

  get selected_commit () {
    return document.querySelector('#commits-select').selectedOptions[0].value
  }

  get selected_commit_idx () {
    return this.commitsChoice._highlightPosition
  }

  connect () {
    Legends.button_outer_opacity = 0.0

    if(window.gon.current_keyboard.length > 0) {
      this.legends = new Legends(window.gon.keyboards[window.gon.current_keyboard][window.gon.current_branch][0].layout)

      this.populateKeyboards()
      this.populateBranches(window.gon.current_keyboard)
      this.populateCommits(window.gon.current_keyboard, window.gon.current_branch)
    }

    this.displayStatus = 'all'

    window.legends_controller = this
  }

  registerCommitsMouseEvents() {
    document.querySelectorAll('#commits-select-wrapper .choices__item--choice').forEach((el) => {
      el.addEventListener('mouseover', (event) => { this.showCommitPreview(event.target.dataset.value) }, false)
      el.addEventListener('mouseout', (_) => { this.hideCommitPreview() }, false)
    })
  }

  populateKeyboards () {
    const keyboards_select = document.querySelector('#keyboards-select')

    Object.keys(gon.keyboards).forEach((keyboard) => {
      const keyboard_option = document.createElement('option')
      keyboard_option.text = keyboard
      keyboard_option.value = keyboard
      keyboard_option.selected = (keyboard == window.gon.current_keyboard)
      keyboards_select.add(keyboard_option)
    })

    this.keyboardsChoice = new Choices('#keyboards-select', { shouldSort: false })
  }

  populateBranches (keyboard) {
    const branches_select = document.querySelector('#branches-select')
    const options = document.querySelectorAll('#branches-select > option')

    if (options.length > 0) {
      if (this.branchesChoice !== undefined) this.branchesChoice.destroy()
      options.forEach((option) => { option.remove() })
    }

    Object.keys(window.gon.keyboards[keyboard]).forEach((branch) => {
      const branch_option = document.createElement('option')
      branch_option.text = branch
      branch_option.value = branch
      branch_option.selected = (window.gon.current_keyboard === keyboard && branch === window.gon.current_branch)
      branches_select.add(branch_option)
    })

    this.branchesChoice = new Choices('#branches-select', { shouldSort: false })
  }

  populateCommits (keyboard, branch) {
    const commits_select = document.querySelector('#commits-select')
    const options = document.querySelectorAll('#commits-select > option')

    if (options.length > 0) {
      if (this.commitsChoice !== undefined) this.commitsChoice.destroy()
      options.forEach((option) => { option.remove() })
    }

    window.gon.keyboards[keyboard][branch].forEach((commit) => {
      const commit_option = document.createElement('option')
      commit_option.text = commit.message
      commit_option.value = commit.hash
      commits_select.add(commit_option)
    })

    this.commitsChoice = new Choices('#commits-select', { shouldSort: false })

    document.getElementById('commits-select').addEventListener('showDropdown', () => {
      this.registerCommitsMouseEvents()
    })
  }

  checkoutKeyboard () {
    this.populateBranches(this.selected_keyboard)
    this.populateCommits(this.selected_keyboard, this.selected_branch)
    this.checkoutCommit()
  }

  checkoutBranch () {
    this.populateCommits(this.selected_keyboard, this.selected_branch)
  }

  checkoutCommit () {
    document.querySelector('#layout-editor').innerHTML = ''
    this.legends = new Legends(window.gon.keyboards[this.selected_keyboard][this.selected_branch][this.selected_commit_idx].layout)
    this.hideCommitPreview()
  }

  showAll () {
    this.legends.show('all')
    this.displayStatus = 'all'
    this.clearAllButtons()
    this.displayAllButtonTarget.classList.add('is-danger')
  }

  showOnlyBackground () {
    this.legends.show('background')
    this.displayStatus = 'background'
    this.clearAllButtons()
    this.displayBackgroundButtonTarget.classList.add('is-danger')
  }

  showOnlyTitle () {
    this.legends.show('title')
    this.displayStatus = 'title'
    this.clearAllButtons()
    this.displayTitleButtonTarget.classList.add('is-danger')
  }

  showOnlySubtitle () {
    this.legends.show('subtitle')
    this.displayStatus = 'subtitle'
    this.clearAllButtons()
    this.displaySubtitleButtonTarget.classList.add('is-danger')
  }

  exportPNGLeft () {
    this.legends.saveAsPNG(`${this.selected_keyboard}_${this.selected_branch}_${this.selected_commit.substring(0, 6)}_${this.displayStatus}_left.png`, 'left')
  }

  exportPNGRight () {
    this.legends.saveAsPNG(`${this.selected_keyboard}_${this.selected_branch}_${this.selected_commit.substring(0, 6)}_${this.displayStatus}_right.png`, 'right')
  }

  clearAllButtons () {
    this.displayAllButtonTarget.classList.remove('is-danger')
    this.displayBackgroundButtonTarget.classList.remove('is-danger')
    this.displayTitleButtonTarget.classList.remove('is-danger')
    this.displaySubtitleButtonTarget.classList.remove('is-danger')
  }

  showCommitPreview (hash) {
    const preview_base64 = window.gon.keyboards[window.gon.current_keyboard][window.gon.current_branch].find((c) => {
      return c.hash === hash
    }).preview_base64
    const preview_src = `data:image/jpeg;base64,${preview_base64}`

    document.querySelector('#commit-preview img').src = preview_src
    document.querySelector('#commit-preview-wrapper').classList.remove('is-hidden')
  }

  hideCommitPreview () {
    document.querySelector('#commit-preview-wrapper').classList.add('is-hidden')
  }
}
