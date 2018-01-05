'use strict'
/**
 * Created by jiuzhou.zhang on 2017/11/21.
 */

import React, { Component, PropTypes } from 'react'
import { View, requireNativeComponent } from 'react-native'
import defaults from './defaults'

export default class CandleStickChart extends Component {
  static propTypes = {
    ...View.propTypes,
    ...defaults.propTypes,
    dataSets: PropTypes.array
  }

  render () {
    return <RNCandleStickChart {...this.props} />
  }
}

const RNCandleStickChart = requireNativeComponent('RNCandleStickChart', CandleStickChart)
