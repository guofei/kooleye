# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
        $container = $('#masonry-container')
        $container.imagesLoaded ->
                $container.masonry itemSelector : '.masonry-item'

$ ->
        $("#image-upload-btn").click ->
                $("#image_file").change ->
                        $("#new_image").submit()

                $("#image_file").click()

        $("#new_image").submit ->
                $("#image-upload").attr("style","display:none")
                true



@remove_image = (id) ->
        $("#image-li-" + id).remove()
        $("#thing_images_" + id).remove()
