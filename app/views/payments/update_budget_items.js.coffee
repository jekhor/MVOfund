$('#payment_budget_item_id').empty()
  .append("<%= escape_javascript(render(:partial => 'budget_item_option', :collection => @budget_items, :as => :bi)) %>")
