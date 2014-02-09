App = angular.module("myApp", [
  'ngCookies'
  'ngResource'
  'ui'
  "ngSanitize"
  "myApp.filters"
  "myApp.services"
  "myApp.directives"
  "myApp.controllers"
  ]).config ["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/search",
    templateUrl: "partials/search.html"
    controller: "SearchCtrl"

  $routeProvider.otherwise redirectTo: "/search"
]
App.value('ui.config', {
  select2:
    allowClear: true
})

_ = ->

_.isUnsignedInt = (num) ->
  return true if "#{num}".match /^[0-9]+$/g
  return false

_.debug = (arguments_)->
  # デバッグ関数を切り替え
  DEBUG = true
  if DEBUG
    return console.log arguments_
  else
  # コール可能でできるだけコストが低いものを考える
    return ->
  # do not anything

