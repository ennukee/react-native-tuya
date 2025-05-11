
'use strict'

if (process.env.NODE_ENV === 'production') {
  module.exports = require('./react-native-tuya.cjs.production.min.js')
} else {
  module.exports = require('./react-native-tuya.cjs.development.js')
}
