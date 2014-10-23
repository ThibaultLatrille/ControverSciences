# app/assets/javascripts/users.js.coffee

$(document).ready ->
  $("#users .page").infinitescroll
    navSelector: "nav.pagination" # selector for the paged navigation (it will be hidden)
    nextSelector: "nav.pagination a[rel=next]" # selector for the NEXT link (to page 2)
    itemSelector: "#users tr.user" # selector for all items you'll retrieve
