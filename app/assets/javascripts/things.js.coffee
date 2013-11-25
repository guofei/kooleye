# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
        $("#image-upload-btn").click ->
                $("#image_file").click()

                $("#image_file").change ->
                        $("#new_image").submit()
