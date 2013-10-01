# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  status = $('.js-build-status').attr('data-status')
  if status != "true" && status != "false"
    window.buildPollerId = setInterval ->
      updateBuild()
    , 1000

updateBuild = ->
  $.ajax
    url: $('.js-build-output').attr('data-uri')
    success: (build) ->
      updateFields(build)

updateFields = (build) ->
  buildOutput = $('.js-build-output')
  buildOutput.html(build.output)
  buildOutput[0].scrollTop = buildOutput[0].scrollHeight
  if build.successful isnt null
    $('.js-build-status').html(build.status_phrase)
    $('.js-build-status').attr('data-status', build.successful)
    clearInterval(window.buildPollerId)
    window.buildPollerId = undefined
