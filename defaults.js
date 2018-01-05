'use strict'
/**
 * Created by jiuzhou.zhang on 2017/6/20.
 */

import { PropTypes } from 'react'

const propTypes = {
  doubleTapToZoomEnabled: PropTypes.bool,
  scaleEnabled: PropTypes.bool,
  pinchZoom: PropTypes.bool,
  chartDescription: PropTypes.object,
  legend: PropTypes.object,
  xAxis: PropTypes.object,
  leftAxis: PropTypes.object,
  rightAxis: PropTypes.object,
  viewPortOffsets: PropTypes.object,
  marker: PropTypes.object
}

export default {
  propTypes
}
