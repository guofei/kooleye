# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
        masonryRunner = ->
                $container = $('#masonry-container')
                $container.imagesLoaded ->
                        $container.masonry itemSelector : '.masonry-item'
        masonryRunner()
        $(window).on 'resize orientationchange', ->
                masonryRunner()

$ ->
        $('[data-toggle="tooltip"]').tooltip({'placement': 'bottom'})


$ ->
        $("#upload-btn").click ->
                $("#upload_file").click()

# https://coderwall.com/p/uf2pka
$ ->
        items = $('#carousel-thing .item') ##grab all slides
        heights = [] ##create empty array to store height values
        tallest = 0 ##create variable to make note of the tallest slide
        normalizeHeights = ->
                if items.length
                        return
                ##add heights to array
                items.each (index, element) ->
                        heights.push($(element).height())
                ##cache largest value
                tallest = Math.max.apply null, heights
                items.each (index, element) ->
                        $(element).css('min-height', tallest + 'px')
        normalizeHeights()
        $(window).on 'resize orientationchange', ->
                ##reset vars
                tallest = 0
                heights.length = 0
                ##reset min-height
                items.each (index, element) ->
                        $(element).css('min-height', '0')
                ##run it again
                normalizeHeights()

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

