# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
        $container = $('#masonry-container')
        $container.imagesLoaded ->
                $container.masonry itemSelector : '.masonry-item'

$ ->
        $("#upload-btn").click ->
                $("#upload_file").click()

jQuery ->
        $('#upload_file').attr('name','image[file]')
        $('#new_upload').fileupload
                dataType: 'script'
                add: (e, data) ->
                        types = /(\.|\/)(gif|jpe?g|png)$/i
                        file = data.files[0]
                        if types.test(file.type) || types.test(file.name)
                                data.context = $(tmpl("template-upload", file))
                                $('#new_upload').append(data.context)
                                $("#upload-btn").attr("style","display:none")
                                data.submit()
                        else
                                alert("#{file.name} is not a gif, jpg or png image file")
                progress: (e, data) ->
                        if data.context
                                progress = parseInt(data.loaded / data.total * 100, 10)
                                data.context.find('.progress-bar').css('width', progress + '%')

@remove_image = (id) ->
        $("#rm-image-" + id).click()
        $("#image-li-" + id).remove()

