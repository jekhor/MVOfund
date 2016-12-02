# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'change', '#payment_campaign_id', (evt) ->
    $.ajax '/payments/update_budget_items',
      type: 'GET'
      dataType: 'script'
      data: {
        campaign_id: $('#payment_campaign_id option:selected').val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic budget items select OK!")

