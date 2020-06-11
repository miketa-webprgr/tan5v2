jQuery.editWordnote = function(){
  /////// tango_config
  /// show tango config panel
  let changedFlagForWordnote = false;
  $(document).on('click','[id*="edit-no-"]',function(){
    $('#edit-window').fadeIn();
    let editList = $(this).siblings();
    let wordnoteId = $(this).attr("id").split("-").pop();
    $('#edit_wordnote_id').val(wordnoteId)
    $.each(editList,function(){
      let name = $(this).attr("name").replace(/-\d+/,"");
      let val = $(this).attr("value")
      if (val){
        if (name == "is_open"){
          if(val == "true"){
            $('#is_open').prop('checked', true);

          }else{
            $('#is_open').prop('checked', false);
          };
        }else{
          $('#' + name).val(val);
        }
      };
    });

    ///csv url
    dl_url = '/users/' + $('#current_user_id').val() +'/wordnotes/' + $('#edit_wordnote_id').val() +  '/download_csv'
    $('.download-csv').attr('href',dl_url)
    ul_url = '/users/' + $('#current_user_id').val() +'/wordnotes/' + $('#edit_wordnote_id').val() +  '/upload_csv'
    $('.upload-csv').attr('href',ul_url)
    $('.upload-csv').attr('action',ul_url)
  });

  ///if change parameter 

  $('#edit-window').on('change','.edit-item',function(){
    changedFlagForWordnote = true;
    let id = $(this).attr("id");
    let val = $(this).val();
    let params = {wordnote: {}};
    if(id == "is_open"){ 
      if($('input.edit-item:checked').prop("checked")){
        val = true
      };
    };
    params["wordnote"][id] = val;
    //params["wordnote"]["id"] = $('#edit_wordnote_id').val();
    editWordnote(params);
  });

  
  /// update config data by ajax
  function editWordnote(editWordnoteParams){
    $.ajax({
        url: '/users/' + $('#current_user_id').val()  + '/wordnotes/' + $('#edit_wordnote_id').val(),
        type: "PATCH",
        data: editWordnoteParams,
        dataType: "text",
        beforeSend: function(xhr){
          xhr.setRequestHeader('X-CSRF-Token',$('meta[name="csrf-token"]').attr('content'));
        },
        //success: function(data){ alert("y");},
        //error: function(XMLHttpRequest, textStatus, errorThrown){ alert("error2");console.log(textStatus);},


      
    });
  };



  /// modal close
  $('#edit-window .modal-close').on('click',function(){
    if( changedFlagForWordnote == true){
      $('#wordnote-edit').html('<p>適用中...</p>');
      location.reload();
    }else{
      $('.modal').fadeOut();
    };
  });


};
