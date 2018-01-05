'use strict'
/**
 * Created by jiuzhou.zhang on 17/4/20.
 */

import React, { Component, PropTypes } from 'react'
import { View, requireNativeComponent } from 'react-native'
import defaults from './defaults'

export default class LineChart extends Component {
  static propTypes = {
    ...View.propTypes,
    ...defaults.propTypes,
    title: PropTypes.string,
    dataSets: PropTypes.array
  }

  static defaultProps = {
    dataSets: []
  }

  render () {
    return <RNLineChart {...this.props} />
  }
}

const RNLineChart = requireNativeComponent('RNLineChart', LineChart)
