// This file is automatically compiled by Webpack, along with any other files
// present in this directory. Youre encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so itll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("chartkick")
require("chart.js")
require("toastr")
import "bootstrap"
import "@fortawesome/fontawesome-free/css/all.css"
import I18n from "i18n-js/index.js.erb"
window.I18n = I18n
import toastr from 'toastr'
window.toastr = toastr
toastr.options = {
  "closeButton": false,
  "positionClass": "toast-top-right",
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag rails.png %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context(../images, true)
// const imagePath = (name) => images(name, true)
