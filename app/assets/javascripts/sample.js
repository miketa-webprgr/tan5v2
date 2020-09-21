jQuery.config_modal = function(){
  /////// tango_config
  /// show tango config panel
  let changedFlagForLearn = false;
  $(document).on('click','[id*="config-no-"]',function(){
    $('#config-window').fadeIn();
    let configList = $(this).siblings();
    let wordnoteId = $(this).attr("id").split("-").pop();
    $('#tango_config_wordnote_id').val(wordnoteId)
    $.each(configList,function(){
      let name = $(this).attr("name").replace(/-\d+/,"");
      let val = $(this).attr("value")
      if (name == "font_size"){
        $('#character-size-preview').css('font-size', val + "px")
      }
      if (val){
        if (name == "continue"){
          if(val == "true"){
            $('#continue').prop('checked', true);

          }else{
            $('#continue').prop('checked', false);
          };
        }else{
          $('#' + name).val(val);
        }
      };
    });
  });

  $('#tango-config').on('change','.config-item',function(){
    changedFlagForLearn = true;
    let id = $(this).attr("id");
    let val = $(this).val();
    let params = {tango_config: {}};
    if(id == "continue"){ 
      if($('input.config-item:checked').prop("checked")){
        val = true
      };
    };
    if(id == "font_size"){ 
      $('#character-size-preview').css('font-size', val + "px")
    };
    params["tango_config"][id] = val;
    params["tango_config"]["wordnote_id"] = $('#tango_config_wordnote_id').val();
    changeConfigData(params);
  });

  
  /// update config data by ajax
  function changeConfigData(tangoConfigParams){
    $.ajax({
        url: '/change_tango_config',
        type: "post",
        data: tangoConfigParams,
        dataType: "text",
        beforeSend: function(xhr){
          xhr.setRequestHeader('X-CSRF-Token',$('meta[name="csrf-token"]').attr('content'));
        },
        //error: function(XMLHttpRequest, textStatus, errorThrown){ console.log(textStatus);},

      
    });
  };


  /// modal close
  $('#config-window .modal-close').on('click',function(){
    if( $('#learn-wrapper').length > 0 && changedFlagForLearn == true){
      $('#tango-config').html('<p>適用中...</p>');
      location.reload();
    }else{
      $('.modal').fadeOut();
    };
  });


};
