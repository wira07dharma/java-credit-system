"use strict";

var showModal = function(e) {
  parent.$(parent.document).trigger('doModal', e);
}

var onSelect = {
  setTabungan: function(d) {
    $('body').find('#search-memberOID').val(d.memberOID);
    $('body').find('#search-homeAddr').val(d.homeAddr);
    $('body').find('#search-personName').val(d.personName);
    $('body').find('#search-assignContactID').val(d.assignContactID);
  },
  setMemberName: function(d) {
    $('body').find('#search-memberOID').val(d.memberOID);
    $('body').find('#search-homeAddr').val(d.homeAddr);
    $('body').find('#search-noRekening').val(d.noRekening);
    $('body').find('#search-personRekening').val(d.noRekening);
    $('body').find('#search-assignContactID').val(d.assignContactID);
    $('#submit').trigger('click');
  },
};

var dataTableInvoker = {
  shiftAction: function(e) {
    //Call ajax closing
    $(e).find('.show-closing').each(function() {
      var me = this;
      var outside = $(this).data('outside');
      $(this).click(function() {
        var parameter = {id: $(this).data('id')};
        ($(this).data('ask-spv')) || (parameter["user"] = user);
        basicAjax(
                baseUrl("ajax/teller-shift-closing.jsp"),
                function(r) {
                  var element = $('body').find('#shift-container');
                  if (outside) {
                    element = $(r);
                    showModal(element);
                    var f = $(element).find("form");
                    $(f).attr("action", $(f).data("action"));
                    $(f).removeAttr("data-action");
                  } else {
                    $(element).html(r);
                    $(element).modal("show")
                    dataTableInvoker.validateSpv($(element).find('#form-close-teller-shift'));
                  }
                  ;

                  $(element).find('.input-payment').each(function() {
                    $(this).keyup(function() {
                      var nilai = 0;
                      $("body").find('#payment-body').find('.val-money').each(function() {
                        nilai = +nilai + +$(this).val();
                      });
                      mm.unmaskedValue = nilai + "";
                      $(input).html(mm.mask());
                    });
                  });

                  var currentdate = new Date();
                  var hours = (currentdate.getHours() > 9) ? currentdate.getHours() : "0" + currentdate.getHours();
                  var minutes = (currentdate.getMinutes() > 9) ? currentdate.getMinutes() : "0" + currentdate.getMinutes();
                  var seconds = (currentdate.getSeconds() > 9) ? currentdate.getSeconds() : "0" + currentdate.getSeconds();
                  var time = hours + ":" + minutes + ":" + seconds;
                  $(element).find('.closing-time').val($(element).find('.closing-time').data("value") + " " + time);
                  $(element).find('.closingBillTime').html(" : " + time);

                  var mmClosingBalance = new maskMoney(null);
                  $(element).find('.amountCloseClear').each(function() {
                    jMoney(this);
                    $(this).keyup(function() {
                      var nilai = 0;
                      $(element).find('.value-balance').each(function() {
                        nilai = +nilai + +$(this).val();
                      });
                      mmClosingBalance.unmaskedValue = nilai + "";
                      $(element).find('.total-amount-display').val(mmClosingBalance.mask());
                      $(element).find('.total-amount-val').val(mmClosingBalance.unmaskedValue);
                    });
                  });

                },
                parameter
                );
      });
    });

    //Print Shift
    $(e).find('.print-shift').each(function() {
      var me = this;
      var isOpening = ($(this).data('print') == "opening");
      var url = isOpening ? "ajax/teller-shift-print-opening.jsp" : "ajax/teller-shift-print-closing.jsp";
      var parameter = {
        id: $(this).data('id'),
        user: user
      };
      (isOpening) || (parameter['computed'] = $(this).data('computed'));
      $(this).click(function() {
        basicAjax(
                baseUrl(url),
                function(r) {
                  var e = $('body').find('#shift-print');
                  $(e).html(r);
                  $(e).find('.money').each(function() {
                    jMoney(this);
                  });
                  window.print();
                },
                parameter
                );
      });
    });
  },
  validateSpv: function(e) {
    $(e).find('form').each(function() {
      var form = this;
      $(this).attr('action', $(this).data("action"));
      $(this).removeAttr("data-action");
      $(this).on('submit', function(n) {
        n.preventDefault();
        var o = this;
        var param = {};
        $(form).find(".user-form-group").find(".include-check").each(function() {
          param[$(this).attr('name')] = $(this).val();
        });
        basicAjax(
                baseUrl("ajax/user-inspector.jsp"),
                function(r) {
                  var s = JSON.parse(r);
                  if (typeof s === "object") {
                    if (s[0].login) {
                      $(o).find('.spv-oid').val(s[0].oid);
                      $(o).find('.spv-name').val(s[0].name);
                      form.submit();
                      return;
                    }
                  }

                  alert("Login / Password tidak dikenali");
                },
                param);
      });
    });
  }
}

jQuery(function() {
  $('.btn-print').click(function() {
    window.print();
  });
  $('.select2').each(function() {
    var p = $(this).attr('placeholder');
    $(this).select2({
      placeholder: p,
    });
  });
  $('.datetime-picker').datetimepicker({
    weekStart: 1,
    todayBtn: 1,
    autoclose: 1,
    todayHighlight: 1,
    startView: 2,
    forceParse: 0,
    minView: 2, // No time
    // showMeridian: 0
  });

  // Initialize ajax autocomplete:
  $('.autocomplete').each(function() {
    var that = this;
    $(that).autocomplete({
      serviceUrl: $(that).data('action'),
      minChars: 1,
      delimiter: /(,|;)\s*/, // regex or character
      maxHeight: 400,
      zIndex: 9999,
      deferRequestBy: 0, //miliseconds
      noCache: false, //default is false, set to true to disable caching
      lookupFilter: function(suggestion, originalQuery, queryLowerCase) {
        var re = new RegExp('\\b' + $.Autocomplete.utils.escapeRegExChars(queryLowerCase), 'gi');
        return re.test(suggestion.value);
      },
      onSelect: function(data) {
        onSelect[$(that).data('onselect')](data);
      },
      onHint: function(hint) {
        console.log(hint);
      },
      onInvalidateSelection: function() {
        console.log('You selected: none');
      },
      onSearchStart: function(q) {
        q.command = $(that).data('for');
      }
    });
  });

  // Payment System
  var input = $("body").find("#payment-total");
  jMoney(input);
  var x = $("<table></table>");
  $(x).html($("body").find('#payment-body').html());
  $("body").find('#btn-payment-add').click(function() {
    var w = $($(x).html());
    var mx = new maskMoney($(w).find('.money'));
    mx.init();
    $(w).keyup(function() {
      var nilai = 0;
      $("body").find('#payment-body').find('.val-money').each(function() {
        nilai = +nilai + +$(this).val();
      });
      $('#real-payment-total').val(nilai);
      $(input).html(nilai);
      jMoney(input);
      hitungInput();
    });

    var row = $('#paymentRow').val();
    row = Number(row) + 1;
    $('#paymentRow').val(row);
    $(w).find('select').attr('data-row', row);
    $(w).find('#type-payment0').attr("id", "type-payment" + row);
    $(w).find('#simpananId0').attr("id", "simpananId" + row);
    $(w).find('#cardNumber0').attr("id", "cardNumber" + row);
    $(w).find('#bankName0').attr("id", "bankName" + row);
    $(w).find('#validateDate0').attr("id", "validateDate" + row);
    $(w).find('#cardName0').attr("id", "cardName" + row);
    $(w).find('#detail_payment0').attr("id", "detail_payment" + row);
    $("body").find('#payment-body').append(w);

    $(w).find('select').change(function() {
      var id = $(this).val();
      var row = $(this).data('row');
      //panggil fungsi di setoran.jsp
      clearDetailPayment(row);
      checkPaymentType(id, row);
    });

  });

  $("body").find('#btn-payment-remove').click(function() {
    $(input).html("0");
    $('#paymentRow').val(0);
    $('#real-payment-total').val(0);
    var w = $($(x).html());
    var mx = new maskMoney($(w).find('.money'));
    mx.init();
    $(w).keyup(function() {
      var nilai = 0;
      $("body").find('#payment-body').find('.val-money').each(function() {
        nilai = +nilai + +$(this).val();
      });
      $('#real-payment-total').val(nilai);
      $(input).html(nilai);
      jMoney(input);
      hitungInput();
    });
    $("body").find('#payment-body').html(w);
  });


  $("body").find('.input-payment').each(function() {
    $(this).keyup(function() {
      var nilai = 0;
      $("body").find('#payment-body').find('.val-money').each(function() {
        nilai = +nilai + +$(this).val();
      });
      $('#real-payment-total').val(nilai);
      $(input).html(nilai);
      jMoney(input);
    });
  });
  //---

  $(".auto-datatable").each(function() {
    var that = $(this);
    var servletName = $(this).data('action');
    var dataFor = $(this).data('for');
    var userLocationId = $(this).data("location");
    var datafilter = "";
    var privUpdate = "";
    var command = 1;
    $(this).dataTable({
      "bDestroy": true,
      "iDisplayLength": 10,
      "bProcessing": true,
      "bServerSide": true,
      "sAjaxSource": baseUrl(servletName + "?command=" + command + "&FRM_FIELD_DATA_FILTER=" + datafilter + "&FRM_FIELD_DATA_FOR=" + dataFor + "&privUpdate=" + privUpdate + "&FRM_FLD_APP_ROOT=" + baseUrl() + "&USER_LOCATION_ID=" + userLocationId),
      "aoColumnDefs": [
        {
          bSortable: false,
          aTargets: [-1]
        }
      ],
      "oLanguage": {
        "sProcessing": "<div class='progress progress-striped active'><div class='progress-bar progress-bar-primary' style='width: 100%'><b>Please Wait...</b></div></div>"
      },
      "initComplete": function(settings, json) {

      },
      "fnDrawCallback": function(oSettings) {
        $(that).find(".money").each(function() {
          jMoney(this);
        });
        (!$(that).data('invoke')) || dataTableInvoker[$(that).data('invoke')](that);
      },
      "fnPageChange": function(oSettings) {

      }
    });
  });

});