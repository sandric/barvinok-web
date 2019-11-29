import * as d3 from 'd3'

import Legends from '../canvas/legends'

export default class Canvas extends Legends {
  constructor (buttons_data, button_defaults) {
    Legends.button_outer_opacity = 0.7
    super(buttons_data, button_defaults)

    this.registerDotEvents()
    this.registerButtonEvents()
  }

  registerDotEvents () {
    document.querySelectorAll('.canvas-dot').forEach((dot) => {
      d3.select(dot)
        .on('mouseover', (d, i, n) => this.onDotMouseOver(d, i, n))
        .on('mouseout', (d, i, n) => this.onDotMouseOut(d, i, n))
        .on('click', (d, i, n) => this.onDotClick(d, i, n))
    })
  }

  registerButtonEvents () {
    document.querySelectorAll('.canvas-button').forEach((button) => {
      d3.select(button)
        .on('mouseover', (d, i, n) => this.onButtonMouseOver(d, i, n))
        .on('mouseout', (d, i, n) => this.onButtonMouseOut(d, i, n))
        .on('click', (d, i, n) => this.onButtonClick(d, i, n))
    })
  }

  showTooltip () {
    this.tooltip.transition()
      .duration(200)
      .style('opacity', 0.9)
  }

  hideTooltip () {
    this.tooltip.transition()
      .duration(200)
      .style('opacity', 0)
  }

  updateTooltip (id, left, top) {
    this.tooltip.html('Button' + '<br/>' + id)
      .style('left', (left + 10) + 'px')
      .style('top', (top - 45) + 'px')
  }

  unselectAllButtons () {
    const unselected_buttons_data = this.buttons_data.map((button_data) => {
      button_data.selected = false
      const button_element = this.getButtonByID(button_data.id)
      const outer_button_element = button_element.selectAll('.outer-button')

      outer_button_element.attr('fill', Canvas.button_color)

      return button_data
    })

    this.buttons_data = unselected_buttons_data
  }

  generateCode () {
    const selected_ids = this.getSelectedButtons().map(button => button.id)
    const selected_titles = this.getSelectedButtons().map(button => button.title)

    return `//pressing ${selected_titles.join(' + ')}\n` +
           `function on([${selected_ids.join(', ')}]) {\n` +
           "  type('')\n" +
           '}'
  }

  updateButtons (button_data) {
    this.getSelectedButtons().forEach(selected_button_data => {
      const new_button_data = Object.assign(selected_button_data, button_data)

      const dot_data = this.getDotDataByID(new_button_data.id)
      const button = this.getButtonByID(new_button_data.id)
      const inner_button = button.selectAll('.inner-button')
      const title = button.selectAll('.title')
      const subtitle = button.selectAll('.subtitle')

      this.setButtonDataByID(new_button_data.id, new_button_data)

      button
        .datum(new_button_data)
        .attr('transform', `rotate(${new_button_data.angle}, ${this.getDotPosition(dot_data).x}, ${this.getDotPosition(dot_data).y})`)
      inner_button
        .attr('fill', new_button_data.background_color)
      title
        .style('fill', new_button_data.title_color)
        .text(new_button_data.title)
      subtitle
        .style('fill', new_button_data.subtitle_color)
        .text(new_button_data.subtitle)
    })
  }

  onDotMouseOver (d, _, __) {
    this.updateTooltip(d.id, d3.event.pageX, d3.event.pageY)
    this.showTooltip()
  }

  onDotMouseOut (_, i, n) {
    const dot = d3.select(n[i])

    dot.attr('fill', Canvas.dot_color)

    this.hideTooltip()
  }

  onDotClick (d, _, __) {
    const new_button_data = this.button_defaults
    new_button_data.id = d.id
    new_button_data.selected = false

    this.buttons_data.push(new_button_data)
    this.addButton(new_button_data)
    this.registerButtonEvents()

    this.hideTooltip()
  }

  onButtonMouseOver (d, i, n) {
    const button = d3.select(n[i]).select('rect')

    if (!d.selected) button.attr('fill', Canvas.button_hovered_color)

    this.updateTooltip(d.id, d3.event.pageX, d3.event.pageY)
    this.showTooltip()
  }

  onButtonMouseOut (d, i, n) {
    if (d.selected) return

    const button = d3.select(n[i]).select('rect')
    button.attr('fill', Canvas.button_color)

    this.hideTooltip()
  }

  onButtonClick (d, i, n) {
    const button = d3.select(n[i]).select('rect')

    d.selected = !d.selected

    button.attr('fill', (d.selected ? Canvas.button_selected_color : Canvas.button_hovered_color))
    this.setButtonDataByID(d.id, d)

    if (window.button_editor_controller) window.button_editor_controller.setValues(d)

    this.hideTooltip()
  }

  getSelectedButtons () {
    return this.buttons_data.filter((button_data) => {
      return button_data.selected
    })
  }

  getUnselectedButtons () {
    return this.buttons_data.filter((button_data) => {
      return !button_data.selected
    })
  }

  removeSelectedButtons () {
    this.getSelectedButtons().forEach(selected_button_data => {
      this.getButtonByID(selected_button_data.id).remove()
    })

    this.buttons_data = this.getUnselectedButtons()
  }
}
