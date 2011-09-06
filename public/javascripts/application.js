$(function(){

  $('.date').each(function(el){
    var d = _date(el.html())
    if (d.date != 'Invalid Date') {
        el.html( d.format("d/M/yyyy HH:mm") );
    }
  });

    $('input[id^=booking_date]').each(function(el){
        el.set('type','hidden');
        var min_date = _date().date,
            max_date = _date().add({M: 1}).date,
            dummy = $E('input');

        var cal = new Calendar({
            format: "ISO",
            minDate: min_date,
            maxDate: max_date,
            numberOfMonths: 1,
            timePeriod: 15,
            showTime: true,
            update: dummy
        });
        cal.on('change', function(){
            dummy.set('value', _date(this.getDate()).localize())
            el.set('value', _date( this.getDate() ).toISO() );
        });
        cal.setDate( _date(el.get('value')).date );

        if (el.parent().parent().get('id') == "booking_widget") {
            dummy.appendTo( el.parent() );
            cal.assignTo(el.parent());
        } else {
            cal.insertTo(el.parent());
        }
    });
});
