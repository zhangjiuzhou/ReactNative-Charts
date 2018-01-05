'use strict'
/**
 * Created by jiuzhou.zhang on 2017/8/29.
 */

import React, { Component, PropTypes } from 'react'
import { requireNativeComponent, View } from 'react-native'
import defaults from './defaults'

export default class PieChart extends Component {
  static propTypes = {
    ...View.propTypes,
    ...defaults.propTypes,
    holeColor: PropTypes.number,
    drawHole: PropTypes.bool,
    holeRadiusPercent: PropTypes.number,
    transparentCircleRadiusPercent: PropTypes.number,
    rotationEnabled: PropTypes.bool,
    dataSets: PropTypes.array
  }

  render () {
    return <RNPieChart {...this.props} />
  }
}

const RNPieChart = requireNativeComponent('RNPieChart', PieChart)
