# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $(document).on "ready page:load", ->
    parseSize = (size) ->
      suffix = ["o", "ko", "mo", "go", "to", "po"]
      tier = 0
      while size >= 1024
        size = size / 1024
        tier++
      (Math.round(size * 10) / 10).toLocaleString() + " " + suffix[tier]

    render_size_helper = (val) ->
      switch val
        when "0" then ""
        else parseSize val

    oTable = $('#films_t').dataTable(
      sDom: 'lrtip'
      aLengthMenu: [
        [10, 15, 25, 50, 100, 200, -1],
        [10, 15, 25, 50, 100, 200, "Tous"]
      ]
      aoColumns: [
        # 00 Nom
        null,

        # 01 Taille
        bSearchable: false
        mRender: (data, type, full) ->
          return data if type == 'sort'
          render_size_helper data
        asSorting: ["desc", "asc"]
        sType: 'numeric'
      ,
        # 02 Path
        null,

        # 03 Comment
        null,

        # 04 Torrent
        null,

        # 05 Action
        bSearchable: false
        bSortable: false
      ]
      oLanguage:
        sSearch: "Chercher :"
        sZeroRecords: "Pas de résultat"
        sInfo: "Entées _START_ à _END_ sur _TOTAL_"
        sLengthMenu: 'Afficher _MENU_ entrées'
    )

    $("#search_bar").on "keyup", ->
      oTable.fnFilter $("#search_bar").val()

    new $.fn.dataTable.FixedHeader oTable, "offsetTop": 45