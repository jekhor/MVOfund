file_picker_cb = (callback, value, meta) ->
  if (meta.filetype == 'image')
    input = document.createElement('input')

    input.setAttribute('type', 'file')
    input.setAttribute('accept', 'image/*')
    input.onchange = ->
      file = this.files[0]
      id = 'blobid' + (new Date()).getTime()
      blobCache = tinymce.activeEditor.editorUpload.blobCache
      blobInfo = blobCache.create(id, file)
      blobCache.add(blobInfo)

      callback(blobInfo.blobUri(), {title: file.name})

    input.click()


ready = ->
  tinymce.remove()
  tinymce.init({
    selector: "textarea.tinymce",
    plugins: "image link imagetools media table code",
    toolbar: "undo redo code | styleselect | bold italic | alignleft aligncenter alignright alignjustify alignnone | table | link image media",
    link_context_toolbar: true,
    menubar: false,
    file_picker_callback: file_picker_cb,
    file_picker_types: 'image',
    convert_urls: false,
    language: 'ru',
    images_upload_url: '/post_images/upload',
    images_upload_credentials: true,
  })

  amount_text = $('#amount_custom')[0]

  $('.amount-btn').on 'click', (event)->
      amount_text.value = ''

  $('#amount_custom').on "input", (event) ->
    amount = event.target.value
    if amount
      $('.donation-form .amount-btn').each (index, btn) ->
        btn.classList.remove('active')

      $('.donation-form .amount-btn > input').each (index, input) ->
        input.checked = false

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
