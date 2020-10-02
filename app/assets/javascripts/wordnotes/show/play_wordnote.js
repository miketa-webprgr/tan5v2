jQuery.playWordnote = function(){
  let fontSize = $('[name*="font_size-"]').val();$
  $('#learn-wrapper').css({'font-size': Number(fontSize)});$
  let interval = Number($('[name*="timer-"]').val());$
  let lastQuestion = Number( $('[id*="last_question"]').val() );
  let isContinue =  $('[id*="continue-"]').val() ;
  let tangoNumber = 0;
  let tangoArray = [];
  let tangoData = $('#questions').find('tr');
  for(let n = 1; n < tangoData.length ; n++){
    let ans = tangoData.eq(n).find('td').eq(3).text();
    let que = tangoData.eq(n).find('td').eq(2).text();
    let hint = tangoData.eq(n).find('td').eq(4).text();
    let tangoId = tangoData.eq(n).find('td').eq(1).text();
    tangoArray.push({answer: ans, question: que, hint: hint, tangoId: tangoId});
    if(lastQuestion > 0 && tangoId == lastQuestion && isContinue == "true"){tangoNumber = n - 1};
  };
  tangoArray.pop();
  let questionHtml = $('#question-text');
  let answerHtml = $('#answer-text');
  let hintHtml = $('#hint-text');
  let tangosHtml = $('#questions');
  let learnHtml = $('#learn-wrapper');
  let correctBtnHtml = $('#correct-btn');
  let wrongBtnHtml = $('#wrong-btn');
  let deleteBtnHtml = $('#delete-btn');
  let hintBtnHtml = $('#hint-btn');
  let showAllTangosHtml = $('#show-tangos');
  let operationHtml = $('#learn-operation');
  showAllTangos();
  setTango();
  operateStatus();

  function changeTangoStatus(){
      if(answerHtml.attr('class') == 'hidden'){
        showAnswer();
      } else if(answerHtml.attr('class') != 'hidden'){
        changeTangoNumber(1);
        setTango();
      };
  };

  function resetTangoArray(){
    tangoArray = [];
    tangoData = $('#questions').find('tr');
    for(let n = 1; n < tangoData.length ; n++){
      let ans = tangoData.eq(n).find('td').eq(3).text();
      let que = tangoData.eq(n).find('td').eq(2).text();
      let hint = tangoData.eq(n).find('td').eq(4).text();
      let tangoId = tangoData.eq(n).find('td').eq(1).text();
      tangoArray.push({answer: ans, question: que, hint: hint, tangoId: tangoId});
    };
    tangoArray.pop();
  };

  //// auto-btn ( timer )
  let questionInterval ;
  if(interval > 0 ){ runTimer(interval);}
  controlTimer();

  function runTimer(interval){
    $('#auto-btn').addClass('auto-on').html(`<i class="fa fa-stop"></i> (${interval})`);
    cnt = interval;
    displayTimer = setInterval(function(){
      cnt--;
      $('#auto-btn').addClass('auto-on').html(`(${cnt})`);
    },1000);
    questionInterval = setInterval(function(){
      changeTangoStatus();
      clearInterval(displayTimer);
      cnt = interval;
    },interval * 1000);
  };

  function stopTimer(){
    clearInterval(questionInterval);
    clearInterval(displayTimer);
    $('#auto-btn').removeClass('auto-on').html(`<i class="fa fa-play"></i> play`);
  };

  function resetTimer(){
    if($('#auto-btn').attr('class').match(/auto-on/)){
      stopTimer();
      runTimer(interval);
    }
  }

  function controlTimer(){
    $('#auto-btn').click(function(){
      if($(this).attr('class').match(/auto-on/)){
        stopTimer();
      }else{
        if(interval > 0 ){
        }else{
          interval = 3;
        };
        runTimer(interval);
      }
    });
  };

  function setTango(){
    resetTangoArray();
    getTangoData();
    $('#tango-number').text(tangoNumber + 1);
    answerHtml.addClass('hidden'); 
    questionHtml.text(tangoArray[tangoNumber].question);
    answerHtml.html(tangoArray[tangoNumber].answer.replace(/\n/g,"<br>"));
    hintHtml.text(' ' + tangoArray[tangoNumber].hint);
    wrongBtnHtml.addClass('hidden');
    correctBtnHtml.addClass('hidden');
  }
  function showAnswer(){
    answerHtml.removeClass('hidden');
    wrongBtnHtml.removeClass('hidden');
    correctBtnHtml.removeClass('hidden');
  }
  
  
  function showAllTangos(){
    if( $('#current_user_id').val() == location.pathname.split("/")[2] ){ 
      showAllTangosHtml.click(function(){
        if(tangosHtml.attr('class').match(/hidden/)){
          tangosHtml.removeClass('hidden');
          showAllTangosHtml.html('<i class="fa fa-window-close"></i>');
        } else {
          tangosHtml.addClass('hidden');
          showAllTangosHtml.html('<i class="fa fa-book-open"></i>');
        };
      });
    }
  };
  function operateStatus(){
    /// #btn => resetTangoArray
    $('#questions').on('click',"[class*='update-btn'] , [class*='create-btn'], [class*='delete-btn']",function(){
      resetTangoArray();
    });

    /// edit tango
    $(document).on('dblclick',"[id*='tango-no-'] > td",function(){
      let attr = $(this).attr('class');
      let value = $(this).text();
      if (!attr){} else if (attr.length > 1){
        $(this).removeClass(attr);
        if (attr == "updated_at"){
        }else{
          $(this).siblings().last().find('[class*="updated-text"]').addClass("hidden");
          $(this).siblings().last().find('[class*="btn"]').removeClass("hidden");
          let textarea = jQuery(jQuery.parseHTML('<textarea style="width:100%;"></textarea>')).attr({
            class: "tango_" + attr,
            default: value
          }).val(value);
          $(this).html(textarea);
        };
      };
    });

    $("table").on('input',"[id*='tango-no-'] > td > textarea",function(){
      let value = $(this).val();
      let target = "#" + $(this).attr('class');
      $(this).parent().siblings().last().find(target).attr({value: value});
    });

    $("table").on('click',"[class*='update-cancel-btn']",function(){
      $(this).parent().siblings().children("textarea").each(function(){
        let value = $(this).attr('default');
        let attr = $(this).attr("class").split("_").pop();
        $(this).parent().addClass(attr).html(value);
      });
      
      $(this).parent().find('[class*="updated-text"]').removeClass("hidden");
      $(this).parent().find('[class*="btn"]').addClass("hidden");
    });

    // create new tango
    $("[id*='create-new-tango']").on('click',"[class*='new-btn']",function(){
      $(this).parent().siblings().find('textarea').removeClass("hidden")
      $(this).parent().siblings().find('[class*="btn"]').removeClass("hidden")
    });

    $("[id*='create-new-tango']").on('input','textarea',function(){
      let value = $(this).val();
      let target = '[name="' + $(this).attr('class') +'"]'
      $(this).parent().siblings().last().find(target).attr({value: value});
    });

    $("[id*='create-new-tango']").on('click',"[class*='create-cancel-btn']",function(){
      $(this).parent().siblings().find('textarea').addClass("hidden")
      $(this).siblings().find('[class*="btn"]').addClass("hidden")
      $(this).addClass("hidden")
    });

    /// save last question
    $(window).on('beforeunload', function() { 
      let lastQuestion = tangoArray[tangoNumber].tangoId;
      let params = {tango_config: {}};
      let wordnoteId = Number($('[id*="config-no-"]').attr("id").split("-").pop());
      params["tango_config"]["wordnote_id"] = wordnoteId;
      params["tango_config"]["last_question"] = lastQuestion;
       $.ajax({
           url: '/change_tango_config',
           type: "post",
           data: params,
           dataType: "text",
           beforeSend: function(xhr){
             xhr.setRequestHeader('X-CSRF-Token',$('meta[name="csrf-token"]').attr('content'));
           },
       });
     });

    /// delete checked tangos
    $("table").on('change',"[id*='delete-check-']",function(){
      resetDeleteHiddenField();
    });

    $("[class*='delete-check-all']").on('change',function(){
      if ($(this).prop('checked')){
        $("[id*='delete-check-']").each(function(){
          $(this).prop('checked', true);
        });
      }else{
        $("[id*='delete-check-']").each(function(){
          $(this).prop('checked', false);
        });
      };
      resetDeleteHiddenField();
    });

    ////// control panel 

    $(".c-small").hover(
      function(){
        $(this).addClass("hover-small");
      },
      function(){
        $(this).removeClass("hover-small");
      }
    );


    ////// star
    $("[id*='star-']").hover(function(){
      let starNumber = $(this).attr("id").split('-').pop();
      $.highlightStars(Number(starNumber));
    });
    $("[id*='star-']").click(function(){
      let starNumber = $(this).attr("id").split('-').pop();
      changeTangoData({star: starNumber});
      $('#flash-message').html('<span class="alert alert-warning">★を ' + starNumber  + ' に設定しました</span>').hide().fadeIn(300);
      $(function(){
        setTimeout("$('.alert.alert-warning').fadeOut('slow')", 500);
      });
    });

    ////// tango panel 
    learnHtml.click(function(){
      //if(answerHtml.attr('class') == 'hidden'){
      //  changeTangoData({trial_num: true}
      //)};
      changeTangoStatus();
      resetTimer();
    });
    wrongBtnHtml.click(function(){
      changeTangoData({wrong_num: true, trial_num: true});
      changeTangoStatus();
      resetTimer();
      $('#flash-message').html('<span class="alert alert-danger">ミス</span>').hide().fadeIn(100);
      $(function(){
      setTimeout("$('.alert.alert-danger').fadeOut('slow')", 300);
      });
    });
    correctBtnHtml.click(function(){
      changeTangoData({trial_num: true});
      changeTangoStatus();
      resetTimer();
      $('#flash-message').html('<span class="alert alert-success">正解</span>').hide().fadeIn(100);
      $(function(){
      setTimeout("$('.alert.alert-success').fadeOut('slow')", 300);
      });
    });

    /// modal
    /// modal hint
    hintBtnHtml.click(function(){
      $('#hint-window').fadeIn(200);
    });
    $('#hint-window .modal-close').on('click',function(){
      $('.modal').fadeOut(200);
    });

    ////
    $("[class*='to-1']").click(function(){
       changeTangoNumber(-1);
       setTango();
    });
    $("[class*='to-10']").click(function(){
       changeTangoNumber(-9);
       setTango();
    });
    $("[class*='to+1']").click(function(){
       changeTangoNumber(1);
       setTango();
    });
    $("[class*='to+10']").click(function(){
       changeTangoNumber(9);
       setTango();
    });
  };

  function resetDeleteHiddenField(){
      let tmp = ""
      $('input:checked').each(function(){
        if( $(this).attr("id") === undefined){ return true; };
        let value = $(this).attr("id").split("-").pop();
        let id = $(this).attr("id").split("-").pop();
        tmp += '<input type="hidden" name="tangos[]" value=' + value + '>';
        console.log(id);
      });
      $("[name*='tangos']").remove();
      tmp = jQuery(jQuery.parseHTML(tmp));
      deleteBtnHtml.append(tmp);
  };

  function changeTangoNumber(num){
        if(tangoNumber + num >= tangoData.length -2){
          tangoNumber = 0;
         }else if(tangoNumber + num < 0){
          tangoNumber = tangoData.length - 3;
         }else{
           tangoNumber += num;
         };
  };

  function getTangoData(){
    $.ajax({
      url: '/tangos/' + tangoArray[tangoNumber].tangoId + '/get_tango_data',
      type: "get",
      dataType: "script",
      beforeSend: function(xhr){
        xhr.setRequestHeader('X-CSRF-Token',$('meta[name="csrf-token"]').attr('content'));
      },
    });
  };

  function changeTangoData(tangoDataParams){
    let wordnoteId = Number($('[id*="config-no-"]').attr("id").split("-").pop());
    tangoDataParams.wordnote_id = wordnoteId;
    $.ajax({
      url: '/tangos/' + tangoArray[tangoNumber].tangoId + '/change_tango_data',
      type: "post",
      data: tangoDataParams,
      dataType: "script",
      beforeSend: function(xhr){
        xhr.setRequestHeader('X-CSRF-Token',$('meta[name="csrf-token"]').attr('content'));
      },
    });
  };
};
