ready = ->
  $('.wysiwyg').froalaEditor({
    imageUploadURL: '/post_images/upload',
    imageUploadMethod: 'POST',
    imageUploadParam: 'file',
    imageUploadParams: {
	    authenticity_token: AUTH_TOKEN
    }
  })

$(document).ready(ready)
