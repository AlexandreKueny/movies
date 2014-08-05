# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $(document).on "ready page:load", ->
    oTable = $('#t_films_t').dataTable(
      sDom: 'lrtip'
      aLengthMenu: [
        [10, 15, 25, 50, 100, 200, -1],
        [10, 15, 25, 50, 100, 200, "Tous"]
      ]
      aoColumns: [
        # 00 Nom
        null,

        # 01 Size
        null,

        # 02 Torrent
        null,

        # 03 Action
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