jQuery ->
  $('.file-upload-choose').click (e) ->
    e.preventDefault
    $(this).closest('form').children('input[type="file"]').click()
  $('#new_image').fileupload
    dataType: "script"
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        console.log data
        data.context = $(tmpl("template-upload", file).trim())
        $('#new_image').append(data.context)
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        console.log data
        data.context.find('.bar').css('width', progress + '%')
