import * as d3 from 'd3'
import { saveSvgAsPng } from 'save-svg-as-png'

import ButtonEditor from '../canvas/button_editor'

export default class Legends {
  static get dot_color() { return 'grey' }
  static get dot_hovered_color() { return 'red' }

  static get button_color() { return 'grey' }
  static get button_hovered_color() { return 'red' }
  static get button_selected_color() { return 'blue' }

  static button_outer_opacity = 0.7

  constructor (buttonsData, buttonDefaults) {
    if (this.isPlausible()) this.initialize(buttonsData, buttonDefaults)
  }

  isPlausible () {
    return !(document.getElementById('layout-editor') === undefined)
  }

  initialize (buttons_data, button_defaults) {
    this.svg = d3.select('svg#layout-editor')
    this.tooltip = d3.select('#layout-editor-wrapper')
      .append('div')
      .attr('class', 'tooltip')
      .style('opacity', 0)

    this.width = this.svg.style('width').replace('px', '')
    this.padding = this.svg.style('padding').replace('px', '')
    this.offset = this.width - (12 * 55) - 8

    this.dots_data = []
    this.buttons_data = buttons_data
    this.button_defaults = button_defaults || ButtonEditor.empty_defaults

    this.initializeDotsData()

    this.renderDots()
    this.renderButtons()
  }

  initializeDotsData () {
    for (var iy = 1; iy <= 25; iy++) {
      for (var ix = 1; ix <= 50; ix++) {
        this.dots_data.push({ side: 'L', row: iy, column: ix, id: `L${iy}${ix}` })
        this.dots_data.push({ side: 'R', row: iy, column: ix, id: `R${iy}${ix}` })
      }
    }
  }

  addButton (buttonData) {
    const dot_data = this.getDotDataByID(buttonData.id)
    const button_element = this.svg.append('g')

    button_element.append('rect')
      .attr('class', 'outer-button')
      .attr('x', this.getDotPosition(dot_data).x - 17)
      .attr('y', this.getDotPosition(dot_data).y - 17)
      .attr('width', 34)
      .attr('height', 34)
      .attr('rx', 4)
      .attr('ry', 4)
      .attr('fill', Legends.button_color)
      .style('opacity', Legends.button_outer_opacity)

    button_element.append('rect')
      .attr('class', 'inner-button')
      .attr('x', this.getDotPosition(dot_data).x - 13)
      .attr('y', this.getDotPosition(dot_data).y - 13)
      .attr('width', 26)
      .attr('height', 26)
      .attr('rx', 4)
      .attr('ry', 4)
      .attr('fill', buttonData.background_color)

    button_element.append('text')
      .attr('class', 'title')
      .attr('x', this.getDotPosition(dot_data).x - 10)
      .attr('y', this.getDotPosition(dot_data).y + 1)
      .style('fill', buttonData.title_color)
      .style('font-size', '16px')
      .text(buttonData.title)

    button_element.append('text')
      .attr('class', 'subtitle')
      .attr('x', this.getDotPosition(dot_data).x + 4)
      .attr('y', this.getDotPosition(dot_data).y + 10)
      .style('fill', buttonData.subtitle_color)
      .style('font-size', '12px')
      .text(buttonData.subtitle)

    button_element
      .datum(buttonData)
      .attr('class', 'canvas-button')
      .attr('id', `button_${buttonData.id}`)

    if (buttonData.angle !== undefined) {
      button_element.attr('transform', `rotate(${buttonData.angle}, ${this.getDotPosition(dot_data).x}, ${this.getDotPosition(dot_data).y})`)
    }
  }

  renderDots () {
    const circleElements = this.svg.selectAll('circle').data(this.dots_data)

    return circleElements.enter()
      .append('circle')
      .attr('id', d => { return `dot_${d.id}` })
      .attr('class', 'canvas-dot')
      .attr('cx', d => { return this.getDotPosition(d).x })
      .attr('cy', d => { return this.getDotPosition(d).y })
      .attr('r', 4)
      .attr('fill', Legends.dot_color)
  }

  renderButtons () {
    this.buttons_data.forEach((buttonData) => {
      this.addButton(buttonData)
    })
  }

  getDotByID (id) {
    return d3.select(document.getElementById(`dot_${id}`))
  }

  getButtonByID (id) {
    return d3.select(document.getElementById(`button_${id}`))
  }

  getDotDataByID (id) {
    return this.dots_data.find(data => data.id === id)
  }

  getButtonDataByID (id) {
    return this.buttons_data.find(data => data.id === id)
  }

  setButtonDataByID (id, value) {
    const index = this.buttons_data.findIndex(data => data.id === id)
    this.buttons_data[index] = value
  }

  getDotPosition (data) {
    return { x: (data.side === 'L' ? data.column * 12 : (data.column * 12) + this.offset), y: (data.row * 12) }
  }

  saveAsPNG (title, half) {
    let options = {}

    if (half === 'left') options = { width: this.width / 2 }
    else if (half === 'right') options = { width: this.width / 2, left: (this.width / 2 + 40) }

    saveSvgAsPng(document.getElementById('layout-editor'), title, options)
  }

  exportSVG () {
    return this.svg.html()
  }

  show (type) {
    this.buttons_data.forEach((buttonData) => {
      const buttonElement = this.getButtonByID(buttonData.id)
      const innerButtonElement = buttonElement.selectAll('.inner-button')
      const titleElement = buttonElement.selectAll('.title')
      const subtitleElement = buttonElement.selectAll('.subtitle')

      switch (type) {
        case 'all': innerButtonElement.attr('fill', buttonData.background_color)
          titleElement.style('opacity', 1.0)
          subtitleElement.style('opacity', 1.0)
          break
        case 'background': innerButtonElement.attr('fill', buttonData.background_color)
          titleElement.style('opacity', 0.0)
          subtitleElement.style('opacity', 0.0)
          break
        case 'title': innerButtonElement.attr('fill', 'transparent')
          titleElement.style('opacity', 1.0)
          subtitleElement.style('opacity', 0.0)
          break
        case 'subtitle': innerButtonElement.attr('fill', 'transparent')
          titleElement.style('opacity', 0.0)
          subtitleElement.style('opacity', 1.0)
          break
      }
    })
  }
}
