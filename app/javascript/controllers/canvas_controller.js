import { Controller } from "stimulus"
import Choices from 'choices.js'

export default class extends Controller {
  static targets = ['newBranch', 'newKeyboard']

  connect () {
    this.populateKeyboards()
    this.populateBranches()
    this.populateCommits(window.gon.current_branch)

    window.canvas_controller = this
  }

  populateKeyboards () {
    const keyboardsSelect = document.querySelector('#keyboards-select')

    window.gon.keyboards.forEach((keyboard) => {
      const keyboardOption = document.createElement('option')
      keyboardOption.text = keyboard
      keyboardOption.value = keyboard
      keyboardOption.selected = (keyboard === window.gon.current_keyboard)
      keyboardsSelect.add(keyboardOption)
    })

    const choiceSelect = new Choices('#keyboards-select', {
      shouldSort: false,
      callbackOnCreateTemplates: function (template) {
        return {
          choice: (classNames, data) => {
            return template(`<div class="is-flex"><a class="select-delete-button delete is-small is-danger mt-15 ml-10 mr-10 ${(data.value === window.gon.current_keyboard ? 'is-invisible' : '')}" data-value="${data.value}"></a><div class="${classNames.item} ${classNames.itemChoice} ${data.disabled ? classNames.itemDisabled : classNames.itemSelectable}" data-select-text="${this.config.itemSelectText}" data-choice ${data.disabled ? 'data-choice-disabled aria-disabled="true"' : 'data-choice-selectable'} data-id="${data.id}" data-value="${data.value}" ${data.groupId > 0 ? 'role="treeitem"' : 'role="option"'} style="width: calc(100% - 20px)"> ${data.label} </div></div>`)
          }
        }
      }
    })

    choiceSelect.passedElement.element.addEventListener('showDropdown', (_) => {
      document.querySelectorAll('.select-delete-button').forEach((el) => {
        el.addEventListener('click', (event) => { this.destroyKeyboard(event.target.dataset.value) }, false)
      })
    }, false)
  }

  populateBranches () {
    let branches_select = document.querySelector('#branches-select')

    Object.keys(gon.commits).forEach((branch) => {
      let branch_option = document.createElement('option')
      branch_option.text = branch
      branch_option.value = branch
      branch_option.selected = (branch === window.gon.current_branch)
      branches_select.add(branch_option)
    })

    const choiceSelect = new Choices('#branches-select', {
      shouldSort: false,
      callbackOnCreateTemplates: function (template) {
        return {
          choice: (classNames, data) => {
            return template(`<div class="is-flex"><a class="select-delete-button delete is-small is-danger mt-15 ml-10 mr-10 ${(data.value === window.gon.current_branch ? 'is-invisible' : '')}" data-value="${data.value}"></a><div class="${classNames.item} ${classNames.itemChoice} ${data.disabled ? classNames.itemDisabled : classNames.itemSelectable}" data-select-text="${this.config.itemSelectText}" data-choice ${data.disabled ? 'data-choice-disabled aria-disabled="true"' : 'data-choice-selectable'} data-id="${data.id}" data-value="${data.value}" ${data.groupId > 0 ? 'role="treeitem"' : 'role="option"'} style="width: calc(100% - 20px)"> ${data.label} </div></div>`)
          }
        }
      }
    })

    choiceSelect.passedElement.element.addEventListener('showDropdown', (_) => {
      document.querySelectorAll('.select-delete-button').forEach((el) => {
        el.addEventListener('click', (event) => { this.deleteBranch(event.target.dataset.value) }, false)
      })
    }, false)
  }

  populateCommits (branch) {
    const commits_select = document.querySelector('#commits-select')
    let options = document.querySelectorAll('#commits-select > option')

    if (options.length > 0) options.forEach((option) => { option.remove() })

    if (window.gon.commits[branch]) {
      window.gon.commits[branch].forEach((commit) => {
        const commit_option = document.createElement('option')
        commit_option.text = commit.message
        commit_option.value = commit.hash

        commits_select.add(commit_option)
      })
    }

    const choiceSelect = new Choices('#commits-select', { shouldSort: false })

    choiceSelect.passedElement.element.addEventListener('showDropdown', (_) => {
      document.querySelectorAll('#commits-select-wrapper .choices__item--choice').forEach((el) => {
        el.addEventListener('mouseover', (event) => { this.showCommitPreview(event.target.dataset.value) }, false)
        el.addEventListener('mouseout', (_) => { this.hideCommitPreview() }, false)
      })
    }, false)

    choiceSelect.passedElement.element.addEventListener('hideDropdown', (_) => {
      document.querySelectorAll('#commits-select-wrapper .choices__item--choice').forEach((el) => {
        el.removeEventListener('mouseover', (event) => { this.showCommitPreview(event.target.dataset.value) }, false)
        el.removeEventListener('mouseout', (_) => { this.hideCommitPreview() }, false)
      })
    }, false)
  }

  createKeyboard (_) {
    const keyboard = this.newKeyboardTarget.value
    const code = window.code_editor_controller.code
    const layout = JSON.stringify(window.layout_editor_controller.buttons_data, null, 2)
    const button_defaults = JSON.stringify(window.button_editor_controller.button_defaults, null, 2)
    const svg = window.layout_editor_controller.exportSVG()

    window.fetch('/git/init', {
      headers: { 'Content-Type': 'application/json; charset=utf-8' },
      method: 'POST',
      body: JSON.stringify({
        keyboard: keyboard,
        commit: {
          code: code,
          layout: layout,
          button_defaults: button_defaults,
          svg: svg
        }
      })
    }).then((_) => {
      window.location.reload()
    })
  }

  destroyKeyboard (keyboard) {
    window.fetch('/git/destroy', {
      headers: { 'Content-Type': 'application/json; charset=utf-8' },
      method: 'DELETE',
      body: JSON.stringify({ keyboard: keyboard })
    }).then((_) => {
      window.location.reload()
    })
  }

  checkoutKeyboard (event) {
    const keyboard = event.target.selectedOptions[0].value

    window.fetch('/git/switch_keyboard', {
      headers: { 'Content-Type': 'application/json; charset=utf-8' },
      method: 'PUT',
      body: JSON.stringify({ keyboard: keyboard })
    }).then((_) => {
      window.location.reload()
    })
  }

  createBranch (_) {
    const branch = this.newBranchTarget.value

    window.fetch('/git/create_branch', {
      headers: { 'Content-Type': 'application/json; charset=utf-8' },
      method: 'POST',
      body: JSON.stringify({ branch: branch })
    }).then((_) => {
      window.location.reload()
    })
  }

  deleteBranch (branch) {
    window.fetch('/git/delete_branch', {
      headers: { 'Content-Type': 'application/json; charset=utf-8' },
      method: 'DELETE',
      body: JSON.stringify({ branch: branch })
    }).then((_) => {
      window.location.reload()
    })
  }

  checkoutBranch (event) {
    const branch = event.target.selectedOptions[0].value

    window.fetch('/git/switch_branch', {
      headers: { 'Content-Type': 'application/json; charset=utf-8' },
      method: 'PUT',
      body: JSON.stringify({ branch: branch })
    }).then((_) => {
      window.location.reload()
    })
  }

  checkoutCommit (event) {
    const commit = event.target.selectedOptions[0].value

    window.fetch('/git/checkout', {
      headers: { 'Content-Type': 'application/json; charset=utf-8' },
      method: 'PUT',
      body: JSON.stringify({ commit: commit })
    }).then((_) => {
      window.location.reload()
    })
  }

  commit () {
    const code = window.code_editor_controller.code
    const layout = JSON.stringify(window.layout_editor_controller.buttons_data, null, 2)
    const button_defaults = JSON.stringify(window.button_editor_controller.button_defaults, null, 2)
    const svg = window.layout_editor_controller.exportSVG()
    const message = this.targets.find('message').value

    window.fetch('/git/commit', {
      headers: { 'Content-Type': 'application/json; charset=utf-8' },
      method: 'POST',
      body: JSON.stringify({ commit: { code: code, layout: layout, message: message, button_defaults: button_defaults, svg: svg } })
    }).then((_) => {
      window.location.reload()
    })
  }

  showCommitPreview (hash) {
    const preview_base64 = window.gon.commits[window.gon.current_branch]
          .find((c) => { return c.hash === hash }).preview_base64
    const preview_src = `data:image/jpeg;base64,${preview_base64}`

    document.querySelector('#commit-preview img').src = preview_src
    document.querySelector('#commit-preview-wrapper').classList.remove('is-hidden')
  }

  hideCommitPreview () {
    document.querySelector('#commit-preview-wrapper').classList.add('is-hidden')
  }

  toggleLayoutEditor () {
    document.querySelector('#layout-editor-wrapper').classList.remove('is-hidden')
    document.querySelector('#button-editor-wrapper').classList.remove('is-hidden')
    document.querySelector('#code-editor-wrapper').classList.add('is-hidden')

    document.querySelector('#toggle-layout-editor').classList.add('has-background-info')
    document.querySelector('#toggle-layout-editor').classList.remove('has-background-white')

    document.querySelector('#toggle-code-editor').classList.add('has-background-white')
    document.querySelector('#toggle-code-editor').classList.remove('has-background-info')
  }

  toggleCodeEditor () {
    document.querySelector('#layout-editor-wrapper').classList.add('is-hidden')
    document.querySelector('#button-editor-wrapper').classList.add('is-hidden')
    document.querySelector('#code-editor-wrapper').classList.remove('is-hidden')

    document.querySelector('#toggle-layout-editor').classList.remove('has-background-info')
    document.querySelector('#toggle-layout-editor').classList.add('has-background-white')

    document.querySelector('#toggle-code-editor').classList.remove('has-background-white')
    document.querySelector('#toggle-code-editor').classList.add('has-background-info')
  }
}
