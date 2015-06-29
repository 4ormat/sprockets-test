class @S3Uploader
  @add_dropzone: (elements) ->
    $(elements).each ->
      element = $(this)
      field_data = $(this).data()
      dropzone = new Dropzone this,
        url: field_data.url
        maxFiles: 1
        previewTemplate:  """
                      <div class="dz-preview dz-file-preview">
                        <div class="dz-details">
                          <img data-dz-thumbnail />
                        </div>
                        <div class="progress"><div class="bar" data-dz-uploadprogress></div></div>
                        <div class="dz-error-message"><span data-dz-errormessage></span></div>
                      </div>
                      """
      dropzone.on 'maxfilesexceeded', (file) ->
        this.removeAllFiles()
        this.addFile(file)
      dropzone.on 'sending', (file, xhr, form_data) ->
        form_data.append "Content-Type", file.type
        form_data.append "key", field_data.key
        form_data.append "acl", "public-read"
        form_data.append "AWSAccessKeyId", field_data.accessKey
        form_data.append "policy", field_data.policy
        form_data.append "signature", field_data.signature
        form_data.append "success_action_status", "201"
      dropzone.on 'success', (file, response) ->
        url = decodeURIComponent $(response).find('Location').text()
        element.find('input').val(url)
        $(file.previewTemplate).find('.progress').addClass('progress-success')
      dropzone.on 'error', (file, message) ->
        console.log "error: " + message
      dropzone.on 'selectedfiles', (files) ->
        element.find('.preview').remove()
